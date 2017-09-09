//
//  AppDelegate.m
//  MonitorSimulator
//
//  Created by savelichalex on 04.09.17.
//  Copyright © 2017 savelichalex. All rights reserved.
//

#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/fcntl.h>
#include <sys/types.h>
#include <errno.h>
#include <semaphore.h>
#import "AppDelegate.h"
#import "DisplayView.h"

#define DISPLAY_FRAME_BUFFER "simulator_frame_buffer"
#define DISPLAY_FRAME_BUFFER_WRITE_SEM "simulator_frame_buffer_ws"
#define DISPLAY_FRAME_BUFFER_READ_SEM "simulator_frame_buffer_rs"
#define DISPLAY_X_SIZE 128
#define DISPLAY_Y_SIZE 128
// 128x128 - dimension, then divide it by off_t size and apply by 8 - one pixel size
#define DISPLAY_FRAME_BUFFER_SIZE DISPLAY_X_SIZE * DISPLAY_Y_SIZE / sizeof(off_t) * 8 + 1

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    int shm;
    sem_t *write_sem, *read_sem;
    
    // Bug with ftrancate in Mac OS,
    // this is cause when shm not closed in app (for i.e. crashed)
    shm_unlink(DISPLAY_FRAME_BUFFER);
    if ( (shm = shm_open(DISPLAY_FRAME_BUFFER, O_CREAT|O_RDWR, 0777)) == -1) {
        int errsv = errno;
        NSLog(@"Couldn't open frame buffer in shm_open, %i", errsv);
        
        return;
    }
    
    if (ftruncate(shm, DISPLAY_FRAME_BUFFER_SIZE) == -1) {
        int errsv = errno;
        NSLog(@"Couldn't open frame buffer in ftrancate, %i", errsv);
        
        return;
    }
    
    self.shm = shm;
    
    sem_unlink(DISPLAY_FRAME_BUFFER_WRITE_SEM);
    if ((write_sem = sem_open(DISPLAY_FRAME_BUFFER_WRITE_SEM, O_CREAT, 0777, 0)) == SEM_FAILED) {
        int errsv = errno;
        NSLog(@"Couldn't open write semaphor, %i", errsv);
        
        return;
    }
    
    sem_unlink(DISPLAY_FRAME_BUFFER_READ_SEM);
    if ((read_sem = sem_open(DISPLAY_FRAME_BUFFER_READ_SEM, O_CREAT, 0777, 0)) == SEM_FAILED) {
        int errsv = errno;
        NSLog(@"Couldn't open read semaphor, %i", errsv);
        
        return;
    }
    
    [self mapDisplayBuffer];
    int x, y;
    for (y = 0; y < DISPLAY_Y_SIZE; y = y + 1) {
        for (x = 1; x <= DISPLAY_X_SIZE; x = x + 1) {
            unsigned char cell = 255;
            NSLog(@"%i", (y * DISPLAY_Y_SIZE) + x);
            self.addr[(y * DISPLAY_Y_SIZE) + x] = cell;
        }
    }
    // [self releaseDisplayBuffer];
    
    DisplayView *dv = (DisplayView*)[[NSApplication sharedApplication] mainWindow].contentViewController.view;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        while (1) {
            if (sem_post(write_sem) == -1) {
                NSLog(@"Couldn't open post in semaphor");
                return;
            }
            
            // [self mapDisplayBuffer];
            dispatch_async(dispatch_get_main_queue(), ^{
                dv.displayBuffer = self.addr;
            });
            
            if (sem_wait(read_sem) == -1) {
                NSLog(@"error sem_wait");
                return;
            }
        }
    });
}

- (void)mapDisplayBuffer {
    char* addr;
    addr = mmap(0, DISPLAY_FRAME_BUFFER_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, self.shm, 0);

    if (addr == (char*)-1) {
        int errsv = errno;
        NSLog(@"Couldn't open frame buffer in mmap, %i", errsv);
        
        return;
    }
    
    self.addr = addr;
}

- (void)releaseDisplayBuffer {
    munmap(self.addr, DISPLAY_FRAME_BUFFER_SIZE);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self releaseDisplayBuffer];
    // munmap(self.addr, DISPLAY_FRAME_BUFFER_SIZE);
    shm_unlink(DISPLAY_FRAME_BUFFER);
    sem_unlink(DISPLAY_FRAME_BUFFER_WRITE_SEM);
    sem_unlink(DISPLAY_FRAME_BUFFER_READ_SEM);
}


@end

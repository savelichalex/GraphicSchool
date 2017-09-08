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
#import "AppDelegate.h"
#import "DisplayView.h"

#define DISPLAY_FRAME_BUFFER "simulator_frame_buffer"
#define DISPLAY_X_SIZE 128
#define DISPLAY_Y_SIZE 128
// 128x128 - dimension, then divide it by off_t size and apply by 8 - one pixel size
#define DISPLAY_FRAME_BUFFER_SIZE DISPLAY_X_SIZE * DISPLAY_Y_SIZE / sizeof(off_t) * 8

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    int shm;
    char* addr;
    
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
    
    addr = mmap(0, DISPLAY_FRAME_BUFFER_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm, 0);
    
    if (addr == (char*)-1) {
        int errsv = errno;
        NSLog(@"Couldn't open frame buffer in mmap, %i", errsv);
        
        return;
    }
    
    NSLog(@"Openning success");
    
    self.addr = addr;
    
    int x, y;
    for (y = 0; y < DISPLAY_X_SIZE; y = y + 1) {
        for (x = 1; x <= DISPLAY_Y_SIZE; x = x + 1) {
            unsigned char cell = 0;
            if (y % 2 == 0 && x % 2 != 0) {
                cell = 255;
            }
            if (y % 2 != 0 && x % 2 == 0) {
                cell = 255;
            }
            
            addr[y + x] = cell;
        }
    }
    
    DisplayView *dv = [[NSApplication sharedApplication] mainWindow].contentViewController.view;
    dv.displayBuffer = addr;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    munmap(self.addr, DISPLAY_FRAME_BUFFER_SIZE);
    shm_unlink(DISPLAY_FRAME_BUFFER);
}


@end

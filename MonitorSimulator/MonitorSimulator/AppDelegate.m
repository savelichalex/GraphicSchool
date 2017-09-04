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

#define DISPLAY_FRAME_BUFFER "simulator_frame_buffer"
// 128x128 - dimension, then divide it by off_t size and apply by 8 - one pixel size
#define DISPLAY_FRAME_BUFFER_SIZE 128 * 128 / sizeof(off_t) * 8

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    int shm;
    char* addr;
    
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
    
    addr = mmap(0, DISPLAY_FRAME_BUFFER_SIZE, PROT_READ, MAP_SHARED, shm, 0);
    
    if (addr == (char*)-1) {
        int errsv = errno;
        NSLog(@"Couldn't open frame buffer in mmap, %i", errsv);
        
        return;
    }
    
    NSLog(@"Openning success");
    
    self.addr = addr;
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    munmap(self.addr, DISPLAY_FRAME_BUFFER_SIZE);
    shm_unlink(DISPLAY_FRAME_BUFFER);
}


@end

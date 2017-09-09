#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/fcntl.h>
#include <sys/types.h>
#include <errno.h>
#include <semaphore.h>
#include <caml/mlvalues.h>

#define DISPLAY_FRAME_BUFFER "simulator_frame_buffer"
#define DISPLAY_FRAME_BUFFER_WRITE_SEM "simulator_frame_buffer_ws"
#define DISPLAY_FRAME_BUFFER_READ_SEM "simulator_frame_buffer_rs"
#define DISPLAY_X_SIZE 128
#define DISPLAY_Y_SIZE 128
// 128x128 - dimension, then divide it by off_t size and apply by 8 - one pixel size
#define DISPLAY_FRAME_BUFFER_SIZE DISPLAY_X_SIZE * DISPLAY_Y_SIZE / sizeof(off_t) * 8

#define OPEN_FRAME_BUFFER_ERROR -1
#define OPEN_FRAME_BUFFER_WITHOUT_ERROR 0

int shared_memory;
char* shared_memory_addr;
sem_t *write_sem, *read_sem;

int error = OPEN_FRAME_BUFFER_ERROR;

CAMLprim value
open_display_buffer(value unit) {
  shared_memory = shm_open(DISPLAY_FRAME_BUFFER, O_RDWR, 0777);

  if (shared_memory < 0) {
    int errsv = errno;
    printf("Error in shm_open: %i", errsv);

    error = OPEN_FRAME_BUFFER_ERROR;

    return Val_unit;
  }

  shared_memory_addr = mmap(0, DISPLAY_FRAME_BUFFER_SIZE, PROT_WRITE, MAP_SHARED, shared_memory, 0);

  if (shared_memory_addr == (char*)-1) {
    int errsv = errno;
    printf("Error in shm_open: %i", errsv);

    error = OPEN_FRAME_BUFFER_ERROR;

    return Val_unit;
  }

  if ((write_sem = sem_open(DISPLAY_FRAME_BUFFER_WRITE_SEM, O_CREAT, 0777, 0)) == SEM_FAILED) {
    int errsv = errno;
    printf("Couldn't open write semaphor, %i", errsv);
    error = OPEN_FRAME_BUFFER_ERROR;

    return Val_unit;
  }

  if ((read_sem = sem_open(DISPLAY_FRAME_BUFFER_READ_SEM, O_CREAT, 0777, 0)) == SEM_FAILED) {
    int errsv = errno;
    printf("Couldn't open read semaphor, %i", errsv);
    error = OPEN_FRAME_BUFFER_ERROR;

    return Val_unit;
  }

  error = OPEN_FRAME_BUFFER_WITHOUT_ERROR;

  return Val_unit;
}

CAMLprim value
set_pixel(value x, value y, value val) {
  int _x, _y, _val;
  _x = Int_val(x);
  _y = Int_val(y);
  _val = Int_val(val);

  if (error == OPEN_FRAME_BUFFER_ERROR) {
    printf("Try to write in not oppened display buffer");
    return Val_unit;
  }

  if (sem_wait(write_sem) == -1) {
    printf("error sem_wait");
    return Val_unit;
  }

  unsigned char converted_value = (unsigned char)_val;

  printf("current value in memory[%i], %i", _x + _y, (unsigned char)shared_memory_addr[x + y]);
  printf("value to write, %i", converted_value);
  shared_memory_addr[x + y] = converted_value;

  if (msync((void *)shared_memory_addr, DISPLAY_FRAME_BUFFER_SIZE, MS_SYNC) < 0) {
    printf("Failed to sync");
    exit(1);
  }

  if (sem_post(read_sem) == -1) {
    printf("error sem_post");
    return Val_unit;
  }

  munmap(shared_memory_addr, DISPLAY_FRAME_BUFFER_SIZE);

  return Val_unit;
}

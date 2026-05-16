cmake_minimum_required(VERSION 3.20)
project(freertos_qemu C ASM)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CPU_FLAGS "-mcpu=cortex-m3 -mthumb -mfloat-abi=soft")
set(CMAKE_C_FLAGS "${CPU_FLAGS} -O0 -g3 -Wall")
set(CMAKE_EXE_LINKER_FLAGS "${CPU_FLAGS} -T${CMAKE_SOURCE_DIR}/linker.ld -nostartfiles")

# FreeRTOS Kernel
add_library(freertos_kernel STATIC
  FreeRTOS-Kernel/tasks.c
  FreeRTOS-Kernel/queue.c
  FreeRTOS-Kernel/list.c
  FreeRTOS-Kernel/timers.c
  FreeRTOS-Kernel/portable/GCC/ARM_CM3/port.c
  FreeRTOS-Kernel/portable/MemMang/heap_4.c
)

target_include_directories(freertos_kernel PUBLIC
  FreeRTOS-Kernel/include
  FreeRTOS-Kernel/portable/GCC/ARM_CM3
  ${CMAKE_SOURCE_DIR}   # untuk FreeRTOSConfig.h
)

# Executable
add_executable(${PROJECT_NAME}.elf
  startup.s
  main.c
)

target_link_libraries(${PROJECT_NAME}.elf freertos_kernel)

# Generate .bin
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
  COMMAND arm-none-eabi-objcopy -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.bin
)
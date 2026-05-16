.syntax unified
.cpu cortex-m3
.thumb

.section .isr_vector, "a"
.word  _estack
.word  Reset_Handler
.word  Default_Handler      /* NMI */
.word  Default_Handler      /* HardFault */
.word  Default_Handler      /* MemManage */
.word  Default_Handler      /* BusFault */
.word  Default_Handler      /* UsageFault */
.word  0
.word  0
.word  0
.word  0
.word  vPortSVCHandler      /* SVC      ← FreeRTOS */
.word  Default_Handler      /* DebugMon */
.word  0
.word  xPortPendSVHandler   /* PendSV   ← FreeRTOS */
.word  xPortSysTickHandler  /* SysTick  ← FreeRTOS */

/* declare external FreeRTOS handlers */
.extern vPortSVCHandler
.extern xPortPendSVHandler
.extern xPortSysTickHandler

.text
.thumb_func
.global Reset_Handler
Reset_Handler:
    ldr r0, =_estack
    mov sp, r0

    ldr r1, =_sdata_flash
    ldr r2, =_sdata
    ldr r3, =_edata
copy_data:
    cmp r2, r3
    bge zero_bss
    ldr r0, [r1], #4
    str r0, [r2], #4
    b copy_data

zero_bss:
    ldr r2, =_sbss
    ldr r3, =_ebss
    mov r0, #0
bss_loop:
    cmp r2, r3
    bge call_main
    str r0, [r2], #4
    b bss_loop

call_main:
    bl main
    b .

.thumb_func
Default_Handler:
    b .
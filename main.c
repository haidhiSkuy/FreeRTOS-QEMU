#include "FreeRTOS.h"
#include "task.h"

// UART0 QEMU MPS2 address
#define UART0_BASE  0x40004000
#define UART0_DATA  (*((volatile uint32_t *)(UART0_BASE + 0x00)))
#define UART0_STATE (*((volatile uint32_t *)(UART0_BASE + 0x04)))
#define UART0_CTRL  (*((volatile uint32_t *)(UART0_BASE + 0x08)))

void uart_init(void) { UART0_CTRL = 0x1; }

void uart_print(const char *s) {
    while (*s) {
        while (UART0_STATE & 0x1); // wait TX ready
        UART0_DATA = *s++;
    }
}

void vTask1(void *pvParams) {
    for (;;) {
        uart_print("Task 1 running\r\n");
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

void vTask2(void *pvParams) {
    for (;;) {
        uart_print("Task 2 running\r\n");
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

int main(void) {
    uart_init();
    uart_print("FreeRTOS QEMU Start!\r\n");

    xTaskCreate(vTask1, "Task1", 128, NULL, 2, NULL);
    xTaskCreate(vTask2, "Task2", 128, NULL, 1, NULL);

    vTaskStartScheduler();
    for (;;);
    return 0;
}
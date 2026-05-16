clone and build
```bash
git clone --recurse-submodules git@github.com:haidhiSkuy/FreeRTOS-QEMU.git
cd FreeRTOS-QEMU
mkdir build && cd build
cmake .. -G Ninja
ninja
```

run with QEMU
```bash
qemu-system-arm \
  -machine mps2-an385 \
  -cpu cortex-m3 \
  -kernel freertos_qemu.elf \
  -nographic \
  -serial mon:stdio
```

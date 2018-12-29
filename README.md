# USB-serial core

Enumerates as USB1.1 serial port seen as /dev/ttyACM0 on linux.
Buffers typed characters. After pressin RETURN prints buffered
characters in reverse order.

# Application side

Application side is the interface as 
seen from soft core CPU or built-in state machine that reverses typed chars.

This core application side "speaks" complete serial bytes with READY/VALID signaling
at maximum speed USB port can provide, not just two RX/TX RS232 lines
at 115200 spped, however such interface can be made too.

It has clock domain crossing so application side serial buffer should
accept any clock synchronous with the application (or soft-core CPU).
Tested with 7.5, 12, 48, 60, 100 and 200 MHz 

PHY side (hardware side) clock should run at 48 MHz or 60 MHz.

# Hardware

Total 6 FPGA pins are used with "27-ohm" interface.
(see ["usb" sheet of ULX3S schematics](https://github.com/emard/ulx3s/tree/master/doc/schematics.pdf)):

    2 differential input pins
    2 single-ended bidirectional pins
    2 single-ended pullup/pulldown control pins (optional)

To save 2 pins, instead of pullup/pulldown control pins,
a fixed pullup resistor of 1.5k between D+ and 3.3V can be used.

USB standard requires tolerance to +5V on any pin,
therefore 27-ohm resistors and 3.6V Zener diodes protect FPGA from +5V.
Core can work without 3.6V Zener diodes if normal
USB devices with properly wired connectors are used.

# Issues

When it doesn't enumerate, try to re-plug or choose another USB port.
This situation should occur quite rarely I hope.

Soft-core UTMI works slightly more reliable (less line errors) 
when clocked at 48 MHz rather than 60 MHz (more line errors).
But for both clocks, usb-serial port should not loose any bytes.

Frequency of line errors also depends on cable quality and USB voltage.

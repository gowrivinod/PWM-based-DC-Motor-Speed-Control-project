#include <lpc214x.h>

#define MOTOR_CONTROL_PIN  (1 << 21)  // Pin P0.21 for motor control
#define FAST_BUTTON_PIN    (1 << 15)  // Pin P0.15 for the Fast button
#define SLOW_BUTTON_PIN    (1 << 16)  // Pin P0.16 for the Slow button

void delay_ms(unsigned int count) {
    unsigned int i, j;
    for (i = 0; i < count; i++)
        for (j = 0; j < 10000; j++);
}

void initPWM() {
    PINSEL0 |= (1 << 10);  // Configure P0.21 as PWM output
    PWMPCR = (1 << 14);    // Enable PWM1
    PWMPR = 30;            // Set the PWM prescaler for a frequency of approximately 1 kHz
    PWMMR0 = 100;          // Set PWM period to 100 (adjust for desired frequency)
    PWMMR1 = 50;           // Set PWM duty cycle to 50 (adjust for desired duty cycle)
    PWMTCR = (1 << 1);     // Reset PWM TC and PR
    PWMTCR = (1 << 0);     // Enable PWM
}

void initButtons() {
    IODIR0 &= ~(FAST_BUTTON_PIN | SLOW_BUTTON_PIN);  // Set P0.15 and P0.16 as input
}

int isFastButtonPressed() {
    return ((IOPIN0 & FAST_BUTTON_PIN) == 0);
}

int isSlowButtonPressed() {
    return ((IOPIN0 & SLOW_BUTTON_PIN) == 0);
}

int main() {
    initPWM();
    initButtons();

    while (1) {
        if (isFastButtonPressed()) {
            PWMMR1 = 100;  // Set PWM duty cycle to 100 for maximum speed
        } else if (isSlowButtonPressed()) {
            PWMMR1 = 50;   // Set PWM duty cycle to 50 for slower speed
        }

        delay_ms(100);    // Adjust the delay based on the application requirements
    }
}
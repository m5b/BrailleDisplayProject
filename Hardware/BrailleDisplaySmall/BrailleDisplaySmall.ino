#include <PID_v1.h>
#include <Servo.h>

#define PIN_REGISTER_CLOCK          2   // Clocks all shift registers
#define PIN_REGISTER_LOAD           5   // Loads data into all shift registers
#define PIN_REGISTER_DATA_OUT_1     7   // Reads from 1st shift register for 1st cam shaft's position
#define PIN_REGISTER_DATA_OUT_2     8   // Reads from 2nd shift register for 2nd cam shaft's position
#define PIN_REGISTER_DATA_OUT_3     11  // Reads from 3rd shift register for 3rd cam shaft's position
#define PIN_REGISTER_DATA_OUT_4     12  // Reads from 4th shift register for 4th cam shaft's position
#define PIN_REGISTER_DATA_OUT_5     13  // Reads from 5th shift register for 5th cam shaft's position
#define PIN_REGISTER_DATA_OUT_6     14  // Reads from 6th shift register for 6th cam shaft's position
#define PIN_SERVO_INPUT_1           3   // Sets 1st cam shaft's speed
#define PIN_SERVO_INPUT_2           4   // Sets 2nd cam shaft's speed
#define PIN_SERVO_INPUT_3           6   // Sets 3rd cam shaft's speed
#define PIN_SERVO_INPUT_4           9   // Sets 4th cam shaft's speed
#define PIN_SERVO_INPUT_5           10  // Sets 5th cam shaft's speed
#define PIN_SERVO_INPUT_6           20  // Sets 6th cam shaft's speed

#define NUM_REGISTER                6   // Number of registers in use

/**
 * Read cam shafts' position using absolute encoders through shift registers.
 * Also clock and shift registers automatically.
 */
class EncoderGroup {
#define TRANSITION_TIME             5   // Input transition rise and fall time in microseconds.
    private:
        uint8_t registerPin[NUM_REGISTER] = {PIN_REGISTER_DATA_OUT_1,
                                             PIN_REGISTER_DATA_OUT_2,
                                             PIN_REGISTER_DATA_OUT_3,
                                             PIN_REGISTER_DATA_OUT_4,
                                             PIN_REGISTER_DATA_OUT_5,
                                             PIN_REGISTER_DATA_OUT_6};

    public:
        // 8-bit position as read by the absolute encoder. 0 = 0 degrees, 255 = ~360 degrees.
        uint8_t position[NUM_REGISTER] = {0};

        // Read position from all encoders into a member array.
        void readPosition() {
            // Load parallel input into register: Pull SH/~LD low.
            digitalWrite(PIN_REGISTER_LOAD, LOW);
            delayMicroseconds(TRANSITION_TIME);
            digitalWrite(PIN_REGISTER_LOAD, HIGH);

            // Read from serial output.
            for (uint8_t bitPosition = 0; bitPosition < 8; ++bitPosition) {
                // Read Q from each connected register.
                for (uint8_t registerIndex = 0; registerIndex < NUM_REGISTER; ++registerIndex) {
                    position[registerIndex] = position[registerIndex] << 1 | digitalRead(registerPin[registerIndex]);
                }

                // Shift the register
                digitalWrite(PIN_REGISTER_CLOCK, HIGH);
                delayMicroseconds(TRANSITION_TIME);
                digitalWrite(PIN_REGISTER_CLOCK, LOW);
            }
        }
} encoderGroup;

class ServoGroup {
    private:
        double kp = 2; // TODO: Find optimal P (Proportional) factor
        double ki = 0; // imo, integral should be ignored because the set point is jumping all over the place between 0 and 255.
        double kd = 6; // TODO: Find optimal D (Derivative) factor

        PID servoPID[NUM_REGISTER];
        double pidInput[NUM_REGISTER];      // Inputs to PID controllers to adjust their outputs
        double pidSetpoint[NUM_REGISTER];   // Setpoints to PID controllers to steer their outputs
        double pidOutput[NUM_REGISTER];     // Outputs of PID controllers.

        Servo servo[NUM_REGISTER];
        uint8_t servoPin[NUM_REGISTER] = {PIN_SERVO_INPUT_1,
                                          PIN_SERVO_INPUT_2,
                                          PIN_SERVO_INPUT_3,
                                          PIN_SERVO_INPUT_4,
                                          PIN_SERVO_INPUT_5,
                                          PIN_SERVO_INPUT_6};

        EncoderGroup* encoderGroup;

    public:
        ServoGroup(EncoderGroup* eg) {
            // Initialize PID instances for all servos
            for (uint8_t i = 0; i < NUM_REGISTER; ++i) {
                servoPID[i] = PID(&pidInput[i], &pidOutput[i], &pidSetpoint[i], kp, ki, kd, DIRECT);
                servoPID[i].SetOutputLimits(90, 180);
                servoPID[i].SetMode(AUTOMATIC);

                servo[i] = Servo();
                servo[i].attach(servoPin[i]);
            }

            encoderGroup = eg;
        }

        /**
         * Set given servo to given position. Does not actually TURN the servo.
         * @param: servo: servo index; should be between 0 and NUM_REGISTER
         * @param: position: 8-bit position. 0 = 0 degrees; 255 = ~360 degrees.
         */
        void setTargetPosition(uint8_t servo, double position) {
            pidSetpoint[servo] = position;
        }

        /**
         * Run one iteration of the "main loop".
         */
        void runIteration() {
            // Update servo input position
            encoderGroup->readPosition();

            // Compute next servo output and turn servo
            for (uint8_t i = 0; i < NUM_REGISTER; ++i) {
                pidInput[i] = encoderGroup->position[i];
                servoPID[i].Compute();
                servo[i].write(pidOutput[i]);
            }
        }
} servoGroup;

void setup() {
    // Set output pins' direction and default signal.
    pinMode(PIN_REGISTER_CLOCK, OUTPUT);
    pinMode(PIN_REGISTER_LOAD,  OUTPUT);
    pinMode(PIN_SERVO_INPUT_1,  OUTPUT);
    pinMode(PIN_SERVO_INPUT_2,  OUTPUT);
    pinMode(PIN_SERVO_INPUT_3,  OUTPUT);
    pinMode(PIN_SERVO_INPUT_4,  OUTPUT);
    pinMode(PIN_SERVO_INPUT_5,  OUTPUT);
    pinMode(PIN_SERVO_INPUT_6,  OUTPUT);

    digitalWrite(PIN_REGISTER_LOAD,  HIGH);
    digitalWrite(PIN_REGISTER_CLOCK, LOW);
}

void loop() {
}

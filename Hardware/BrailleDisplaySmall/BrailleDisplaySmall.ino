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

        /**
         * Pin output code for absolute encoder.
         * Taken from datasheet at http://www.bourns.com/docs/Product-Datasheets/ace.pdf
         * Rotation is divided into 128 positions so the encoder has a 7-bit precision.
         */
        const uint8_t MAP_ENCODER_POSITION_TO_OUTPUT[128] = {
            127, 63, 62, 58, 56, 184, 152, 24, 8, 72, 73, 77, 79, 15, 47, 175,
            191, 159, 31, 29, 28, 92, 76, 12, 4, 36, 164, 166, 167, 135, 151, 215, 223,
            207, 143, 142, 14, 46, 38, 6, 2, 18, 82, 83, 211, 195, 203, 235, 239, 231, 199,
            71, 7, 23, 19, 3, 1, 9, 41, 169, 233, 225, 229, 245, 247, 243, 227, 163, 131,
            139, 137, 129, 128, 132, 148, 212, 244, 240, 242, 250, 251, 249, 241, 209, 193,
            197, 196, 192, 64, 66, 74, 106, 122, 120, 121, 125, 253, 252, 248, 232, 224,
            226, 98, 96, 32, 33, 37, 53, 61, 60, 188, 190, 254, 126, 124, 116, 112, 113,
            49, 48, 16, 144, 146, 154, 158, 30, 94, 95};

        /**
         * Reverse lookup table of the above.
         * Note: Because only 128 positions exist whereas 256 outputs do,
         *       some superfluous outputs are mapped to 0.
         *       Manufacturer's fault if the hardware gives such outputs.
         */
        const uint8_t MAP_ENCODER_OUTPUT_TO_POSITION[256] = {
            0, 56, 40, 55, 24, 0, 39, 52, 8, 57, 0, 0, 23, 0, 36, 13, 120, 0,
            41, 54, 0, 0, 0, 53, 7, 0, 0, 0, 20, 19, 125, 18, 104, 105, 0, 0, 25, 106, 38,
            0, 0, 58, 0, 0, 0, 0, 37, 14, 119, 118, 0, 0, 0, 107, 0, 0, 4, 0, 3, 0, 109,
            108, 2, 1, 88, 0, 89, 0, 0, 0, 0, 51, 9, 10, 90, 0, 22, 11, 0, 12, 0, 0, 42,
            43, 0, 0, 0, 0, 0, 0, 0, 0, 21, 0, 126, 127, 103, 0, 102, 0, 0, 0, 0, 0, 0, 0,
            91, 0, 0, 0, 0, 0, 116, 117, 0, 0, 115, 0, 0, 0, 93, 94, 92, 0, 114, 95, 113,
            0, 72, 71, 0, 68, 73, 0, 0, 29, 0, 70, 0, 69, 0, 0, 35, 34, 121, 0, 122, 0, 74,
            0, 0, 30, 6, 0, 123, 0, 0, 0, 124, 17, 0, 0, 0, 67, 26, 0, 27, 28, 0, 59, 0, 0,
            0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 110, 0, 111, 16, 87, 84, 0,
            45, 86, 85, 0, 50, 0, 0, 0, 46, 0, 0, 0, 33, 0, 83, 0, 44, 75, 0, 0, 31, 0, 0,
            0, 0, 0, 0, 0, 32, 100, 61, 101, 66, 0, 62, 0, 49, 99, 60, 0, 47, 0, 0, 0, 48,
            77, 82, 78, 65, 76, 63, 0, 64, 98, 81, 79, 80, 97, 96, 112, 0};

    public:
        // 7-bit position as read by the absolute encoder. 0 = 0 degrees, 127 = ~360 degrees.
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
                    position[registerIndex] = (position[registerIndex] << 1) | digitalRead(registerPin[registerIndex]);
                }

                // Shift the register
                digitalWrite(PIN_REGISTER_CLOCK, HIGH);
                delayMicroseconds(TRANSITION_TIME);
                digitalWrite(PIN_REGISTER_CLOCK, LOW);
            }

            // Map encoder output to actual position
            for (uint8_t registerIndex = 0; registerIndex < NUM_REGISTER; ++registerIndex) {
                position[registerIndex] = MAP_ENCODER_OUTPUT_TO_POSITION[position[registerIndex]];
            }
        }
} encoderGroup;

class ServoGroup {
    private:
        double kp = 1.5;
        double ki = 4.5;
        double kd = 0;

        PID *servoPID[NUM_REGISTER] = {0};
        double pidInput[NUM_REGISTER];            // Inputs to PID controllers to adjust their outputs
        double pidSetpoint[NUM_REGISTER] = {60};  // Setpoints to PID controllers to steer their outputs
        double pidOutput[NUM_REGISTER];           // Outputs of PID controllers.

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
                servoPID[i] = new PID(&pidInput[i], &pidOutput[i], &pidSetpoint[i], kp, ki, kd, DIRECT);
                servoPID[i]->SetMode(AUTOMATIC);

                // Limit output to 0 (really fast counter-clockwise motion) and
                //               180 (really fast clockwise motion).
                // To prevent overshoots and oscillations, the limits could be narrowed to something like
                //                          45, 135 or
                //                          60, 120.
                // Make sure the numbers add up to 180 to keep the speed uniform in both directions.
                servoPID[i]->SetOutputLimits(0, 180);
                servoPID[i]->SetInputType(CIRCULAR, 0, 127);

                // Allow PID output to differ from target by 1 to prevent tiny oscillations.
                servoPID[i]->SetErrorTolerance(1);

                servo[i] = Servo();
                servo[i].attach(servoPin[i]);
            }

            encoderGroup = eg;
        }

        /**
         * Set given servo to given position. Does NOT actually TURN the servo.
         * Turning is done in runIteration().
         * @param: servo: servo index; should be between 0 and NUM_REGISTER
         * @param: position: 7-bit position. 0 = 0 degrees; 127 = ~360 degrees.
         */
        void setTargetPosition(uint8_t servo, double position) {
            pidSetpoint[servo] = position;
        }

        /**
         * Run one iteration of the "main loop".
         * Call this once every loop()
         */
        void runIteration() {
            // Update servo input position
            encoderGroup->readPosition();

            // Compute next servo output and turn servo
            for (uint8_t i = 0; i < NUM_REGISTER; ++i) {
                pidInput[i] = encoderGroup->position[i];
                servoPID[i]->Compute();

                servo[i].write(pidOutput[i]);
            }
        }
} servoGroup(&encoderGroup);

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

    pinMode(PIN_REGISTER_DATA_OUT_1, INPUT);
    pinMode(PIN_REGISTER_DATA_OUT_2, INPUT);
    pinMode(PIN_REGISTER_DATA_OUT_3, INPUT);
    pinMode(PIN_REGISTER_DATA_OUT_4, INPUT);
    pinMode(PIN_REGISTER_DATA_OUT_5, INPUT);
    pinMode(PIN_REGISTER_DATA_OUT_6, INPUT);

    digitalWrite(PIN_REGISTER_LOAD,  HIGH);
    digitalWrite(PIN_REGISTER_CLOCK, LOW);

    Serial.begin(9600);
}

String inString = "";
void loop() {
    // Testing: Turn the servo to a position given via Serial.
    servoGroup.runIteration();
    delay(50);
    Serial.println(encoderGroup.position[0]);

    while (Serial.available()) {
        uint8_t inChar = Serial.read();
        if (isDigit(inChar)) {
            inString += (char) inChar;
        }
        if ('\n' == inChar) {
            servoGroup.setTargetPosition(0, inString.toInt());
            inString = "";
        }
    }
}

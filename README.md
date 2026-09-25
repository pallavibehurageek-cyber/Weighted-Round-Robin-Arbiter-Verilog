Weighted Round-Robin Arbiter in Verilog

Overview

This project implements a Weighted Round-Robin Arbiter using Verilog HDL.

An arbiter is a digital hardware block that decides which requester gets access to a shared resource when multiple requesters ask for access at the same time.

A Round-Robin Arbiter provides fair access by rotating the priority among requesters instead of continuously giving priority to the same requester.

This implementation extends the basic round-robin concept by assigning different weights/credits to requesters. A requester with a higher weight can receive access more times before its available credit is exhausted.

---

Key Features

- Parameterized number of requesters
- Weighted round-robin scheduling
- Fair resource arbitration
- Priority rotation after every successful grant
- Credit-based access control
- Synchronous operation with clock and reset
- Separate Verilog testbench for simulation

---

Block Diagram

              Request Signals
              request[n-1:0]
                     |
                     v
          +----------------------+
          |                      |
          |  Weighted Round      |
          |  Robin Arbiter       |
          |                      |
          +----------------------+
                     |
                     v
               Grant Signal
                grant[n-1:0]

        clk ------->|
        rst ------->|
        ready ------>|

---

Inputs and Outputs

Signal| Direction| Description
"clk"| Input| Clock signal
"rst"| Input| Reset signal
"request"| Input| Request signals from multiple requesters
"ready"| Input| Indicates that the granted requester can be served
"grant"| Output| Indicates which requester is currently granted access

For the default configuration, "n = 4", so there are four requesters.

Example

request = 4'b1011

This means requesters 3, 1 and 0 are requesting access.

The arbiter selects one eligible requester and generates a one-hot grant signal.

For example:

grant = 4'b0001

means requester 0 has been granted access.

---

Weighted Scheduling

The default configuration uses the following weights:

weights = {3'd4, 3'd2, 3'd1, 3'd1}

The weights represent the initial number of credits available to each requester.

Conceptually:

Requester 3 -> Weight 4
Requester 2 -> Weight 2
Requester 1 -> Weight 1
Requester 0 -> Weight 1

Whenever a requester is successfully granted while "ready" is asserted, its available credit is reduced.

When all requester credits are exhausted, the credits are reloaded from the original weights.

This allows different requesters to receive different amounts of service while maintaining controlled arbitration.

---

Round-Robin Priority

The arbiter maintains a priority mask.

After a requester receives a grant, the priority moves toward the next requester.

For example:

Requester order:

0 -> 1 -> 2 -> 3 -> 0 -> ...

This prevents one requester from continuously receiving priority when other requesters are also waiting.

If there are no eligible requesters after the current priority position, the arbiter searches again from the beginning.

---

RTL Design

The main design is implemented in:

roundRobinArbiter.v

The design contains:

- Request detection
- Priority masking
- Credit tracking
- Grant generation
- Credit decrementing
- Credit reloading
- Priority rotation

The module is parameterized so that the number of requesters and weight width can be changed.

Default parameters:

parameter n = 4;
parameter w = 3;

---

Testbench

The simulation testbench is provided in:

roundRobinArbiter_tb.v

The testbench:

1. Generates a clock
2. Applies reset
3. Activates multiple requests
4. Changes the request pattern
5. Controls the "ready" signal
6. Observes the generated "grant"
7. Stops the simulation

The testbench demonstrates different arbitration conditions, including:

- All requesters active
- Some requesters active
- Ready disabled/enabled
- Single requester active
- No requester active

---

Simulation Flow

The project can be simulated using Verilog-compatible simulators such as:

- Xilinx Vivado
- ModelSim / Questa
- Icarus Verilog
- Verilator

Basic Simulation Flow

Verilog RTL
     |
     v
Testbench
     |
     v
Simulation
     |
     v
Waveform
     |
     v
Verify Grant and Arbitration Behavior

---

Expected Behavior

The arbiter should ensure that:

- At most one requester is granted at a time.
- Only active/requesting clients can receive a grant.
- Priority rotates after a successful grant.
- Credits are reduced when a requester is served.
- Credits are reloaded after all available credits are exhausted.
- The "ready" signal controls when a granted request is actually served.

---

Applications

Weighted round-robin arbitration can be useful in systems where multiple requesters need controlled access to a shared resource.

Possible applications include:

- Bus arbitration
- Network-on-Chip systems
- Memory access control
- Shared communication resources
- Processor/interconnect arbitration
- DMA request scheduling
- FPGA and SoC hardware systems

---

Files

Weighted-Round-Robin-Arbiter-Verilog/
│
├── weighted_round_robin_arbiter.v
├── weighted_round_robin_arbiter_tb.v
└── README.md

---

Technologies Used

- Verilog HDL
- Digital Logic Design
- RTL Design
- Simulation and Verification
- Round-Robin Arbitration
- Weighted Scheduling

---

Learning Outcomes

Through this project, the following concepts can be explored:

- RTL design using Verilog
- Combinational and sequential logic
- Parameterized Verilog modules
- Arbitration and scheduling
- Priority masking
- Credit-based scheduling
- Testbench development
- Simulation-based verification

---

Future Improvements

Possible extensions include:

- Adding more requesters
- Making weights runtime-configurable
- Adding assertions for verification
- Creating a more comprehensive randomized testbench
- Measuring fairness across long simulations
- Performing synthesis and area/timing analysis
- Implementing the design on an FPGA


<!---======================= begin_copyright_notice ============================

Copyright (c) 2019-2021 Intel Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

============================= end_copyright_notice ==========================-->

 

## Opcode

  VME_FBR = 0x56

## Format

| | | | | | | |
| --- | --- | --- | --- | --- | --- | --- |
| 0x56(VME_FBR) | UNIInput | FBRInput | Surface | FBRMbMode | FBRSubMbShape | FBRSubPredMode |
|               | Output   |          |         |           |               |                |


## Semantics




      Video Motion Estimation - fractional and bidirectional refinement

## Description


    Performs Video Motion Estimation with fractional and bidirectional refinement (FBR). See [4] for more detailed information on the VME functionality. This instruction may not appear inside a SIMD control flow block.

- **UNIInput(raw_operand):** The raw operand of a general variable that stores the universal VME payload data. Must have type UB. Must have 128 elements

- **FBRInput(raw_operand):** The raw operand of a general variable that stores the FBR specific payload data. Must have type UB. Must have 128 elements

- **Surface(ub):** The index of the surface variable

- **FBRMbMode(scalar):** The inter macro-block type. Must have type UD. Valid values are:
 
  - 0: 16x16 
  - 1: 16x8 
  - 2: 8x16 
  - 3: 8x8
- **FBRSubMbShape(scalar):** The sub-shape per block for fractional and bidirectional refinement. Must have type UD
 
  - Bit[1..0]: SubMbShape[0]
 
    - 0b00:  8x8 
    - 0b01:  8x4 
    - 0b10:  4x8 
    - 0b11:  4x4 
  - Bit[3..2]: SubMbShape[1]
 
    - 0b00:  8x8 
    - 0b01:  8x4 
    - 0b10:  4x8 
    - 0b11:  4x4 
  - Bit[5..4]: SubMbShape[2]
 
    - 0b00:  8x8 
    - 0b01:  8x4 
    - 0b10:  4x8 
    - 0b11:  4x4 
  - Bit[7..6]: SubMbShape[3]
 
    - 0b00:  8x8 
    - 0b01:  8x4 
    - 0b10:  4x8 
    - 0b11:  4x4
- **FBRSubPredMode(scalar):** The selection of shapes from the input message for performing VME. Must have type UD
 
  - Bit[1..0]: SubMbPredMode[0]
 
    - 0b00:  Forward 
    - 0b01:  Backward 
    - 0b10:  Bidirectional 
    - 0b11:  Illegal 
  - Bit[3..2]: SubMbPredMode[1]
 
    - 0b00:  Forward 
    - 0b01:  Backward 
    - 0b10:  Bidirectional 
    - 0b11:  Illegal 
  - Bit[5..4]: SubMbPredMode[2]
 
    - 0b00:  Forward 
    - 0b01:  Backward 
    - 0b10:  Bidirectional 
    - 0b11:  Illegal 
  - Bit[7..6]: SubMbPredMode[3]
 
    - 0b00:  Forward 
    - 0b01:  Backward 
    - 0b10:  Bidirectional 
    - 0b11:  Illegal
- **Output(raw_operand):** The raw operand of a general variable used to store the VME output data. Must have type UB. Must have 224 elements

#### Properties


## Text
```
    

    VME_FBR (<FBRMbMode>, <FBRSubMbShape>, <FBRSubPredMode>) <surface> <UNIInput> <FBRInput> <output>
```



## Notes



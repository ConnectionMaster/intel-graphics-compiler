/*========================== begin_copyright_notice ============================

Copyright (c) 2021-2021 Intel Corporation

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

============================= end_copyright_notice ===========================*/

#ifndef LLVM_GENX_INTERNALMETADATA_H
#define LLVM_GENX_INTERNALMETADATA_H

#include "llvm/IR/Function.h"

namespace llvm {
namespace genx {

namespace DebugMD {
inline constexpr const char DebuggableKernels[] = "VC.Debug.Enable";
}

namespace FunctionMD {
inline constexpr const char GenXKernelInternal[] = "genx.kernel.internal";
inline constexpr const char VCEmulationRoutine[] = "VC.Emulation.Routine";
}

namespace InstMD {
inline constexpr const char SVMBlockType[] = "SVMBlockType";
inline constexpr const char FuncArgSize[] = "FuncArgSize";
inline constexpr const char FuncRetSize[] = "FuncRetSize";
}

namespace ModuleMD {
inline constexpr const char UseSVMStack[] = "genx.useGlobalMem";
}

namespace internal {

namespace KernelMDOp {
enum {
  FunctionRef,
  OffsetInArgs, // Implicit arguments offset in the byval argument
  ArgIndexes,   // Kernel argument index. Index may not be equal to the IR argNo
                // in the case of linearization
  LinearizationArgs,
  Last
};
}
namespace ArgLinearizationMDOp {
enum {
  Explicit,
  Linearization,
  Last
};
}
namespace LinearizationMDOp {
enum {
  Argument,
  Offset,
  Last
};
}

// ExternalMD is created by vc-intrinsics. Internal has to be created by VC BE.
// This creates initial internal metadata structure. Definition in
// KernelInfo.cpp
void createInternalMD(Function &F);
void replaceInternalFunctionRef(const Function &From, Function &To);

} // namespace internal
} // namespace genx
} // namespace llvm

#endif

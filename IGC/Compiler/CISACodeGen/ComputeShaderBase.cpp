/*========================== begin_copyright_notice ============================

Copyright (C) 2019-2021 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

#include "common/LLVMWarningsPush.hpp"
#include <llvm/Support/ScaledNumber.h>
#include <optional>
#include "common/LLVMWarningsPop.hpp"
#include "Compiler/CISACodeGen/ComputeShaderBase.hpp"
#include "Compiler/CISACodeGen/CSWalkOrder.hpp"
#include "Compiler/CISACodeGen/messageEncoding.hpp"
#include "common/allocator.h"
#include "common/secure_mem.h"
#include <iStdLib/utility.h>
#include <algorithm>
#include "Probe/Assertion.h"

using namespace llvm;

namespace IGC
{
    CComputeShaderBase::CComputeShaderBase(llvm::Function* pFunc, CShaderProgram* pProgram)
        : CShader(pFunc, pProgram) {}

    CComputeShaderBase::~CComputeShaderBase() {}

    std::optional<CS_WALK_ORDER>
    CComputeShaderBase::checkLegalWalkOrder(
        const std::array<uint32_t, 3>& Dims,
        const WorkGroupWalkOrderMD& WO)
    {
        auto is_pow2 = [](uint32_t dim) {
            return iSTD::IsPowerOfTwo(dim);
        };

        const int walkorder_x = WO.dim0;
        const int walkorder_y = WO.dim1;
        const int walkorder_z = WO.dim2;

        const uint32_t dim_x = Dims[0];
        const uint32_t dim_y = Dims[1];
        const uint32_t dim_z = Dims[2];

        uint order0 = (walkorder_x == 0) ? 0 : (walkorder_y == 0) ? 1 : 2;
        uint order1 = (walkorder_x == 1) ? 0 : (walkorder_y == 1) ? 1 : 2;

        if (order0 != order1
            && ((order0 == 0 && is_pow2(dim_x))
                || (order0 == 1 && is_pow2(dim_y))
                || (order0 == 2 && is_pow2(dim_z)))
            && ((order1 == 0 && is_pow2(dim_x))
                || (order1 == 1 && is_pow2(dim_y))
                || (order1 == 2 && is_pow2(dim_z)))
            )
        {
            // Legal walk order for HW auto-gen
            return getWalkOrderInPass(order0, order1);
        }

        return std::nullopt;
    }
}

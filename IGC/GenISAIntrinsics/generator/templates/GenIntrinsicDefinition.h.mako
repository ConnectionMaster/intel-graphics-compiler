/*========================== begin_copyright_notice ============================

Copyright (C) 2023 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/
#pragma once

#include "GenIntrinsicDescription.h"
#include "StringMacros.hpp"
#include "LlvmTypesMapping.h"

#include "common/LLVMWarningsPush.hpp"
#include "llvm/IR/Attributes.h"
#include "llvmWrapper/Support/ModRef.h"
#include "common/LLVMWarningsPop.hpp"

#include <string_view>
#include <array>

namespace IGC
{

static constexpr std::string_view scIntrinsicPrefix = "${IntrinsicFormatter.get_prefix()}";

template<llvm::GenISAIntrinsic::ID id>
struct IntrinsicDefinition;

<%!
from Intrinsic_generator import IntrinsicFormatter
%>\
% for el in intrinsic_definitions:
template<>
class IntrinsicDefinition<llvm::GenISAIntrinsic::ID::${el.name}>
{
public:
    static constexpr llvm::GenISAIntrinsic::ID scID = llvm::GenISAIntrinsic::ID::${el.name};
    using DescriptionT = IntrinsicDescription<scID>;
    using Argument = DescriptionT::Argument;

    static const char* scFunctionRootName;

    static constexpr TypeDescription scResTypes{
        ${IntrinsicFormatter.get_type_definition(el.return_definition.type_definition)}::scType
    };
    % if hasattr(el, 'arguments') and el.arguments and len(el.arguments) > 0:

    static constexpr std::array<TypeDescription, static_cast<uint32_t>(Argument::Count)> scArgumentTypes{
        % for arg in el.arguments:
        ${IntrinsicFormatter.get_argument_type_entry(arg.type_definition, loop.last)}
        % endfor
    };
    % endif
    static const char* scMainComment;
    static const char* scResultComment;
    % if hasattr(el, 'arguments') and el.arguments and len(el.arguments) > 0:

    static const std::array<const char*, static_cast<uint32_t>(Argument::Count)> scArgumentComments;
    % endif
    % if hasattr(el, 'attributes') and el.attributes and len(el.attributes) > 0:

    static constexpr std::array scAttributeKinds = {
        % for attr in el.attributes:
        ${IntrinsicFormatter.get_attribute_entry(attr, loop.last)}
        % endfor
    };
    % endif

    % if hasattr(el, 'memory_effects'):
    static constexpr auto scMemoryEffects =
        ${IntrinsicFormatter.get_memory_effects_from_restrictions(el.memory_effects)};
    % endif
};

% endfor
} // namespace IGC

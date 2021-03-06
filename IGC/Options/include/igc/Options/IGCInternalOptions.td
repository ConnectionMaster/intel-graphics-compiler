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

// This file defines internal options accepted by scalar compiler.
//
//===----------------------------------------------------------------------===//

// IGC internal options {{
let Flags = [IGCInternalOption] in {

// Backend internal options {{
defm replace_global_offsets_by_zero :
  CommonFlag<"replace-global-offsets-by-zero">;

defm kernel_debug_enable : CommonFlag<"kernel-debug-enable">;

defm include_sip_csr : CommonFlag<"include-sip-csr">;

defm include_sip_kernel_debug : CommonFlag<"include-sip-kernel-debug">;

defm include_sip_kernel_local_debug :
  CommonFlag<"include-sip-kernel-local-debug">;

defm use_32_bit_ptr_arith : CommonFlag<"intel-use-32bit-ptr-arith">;

def greater_than_4GB_buffer_required :
  ZeFlag<"opt-greater-than-4GB-buffer-required">;
def : ClFlag<"intel-greater-than-4GB-buffer-required">,
  Alias<greater_than_4GB_buffer_required>;

def has_buffer_offset_arg : ZeFlag<"opt-has-buffer-offset-arg">;
def : ClFlag<"intel-has-buffer-offset-arg">, Alias<has_buffer_offset_arg>;

def buffer_offset_arg_required : ZeFlag<"opt-buffer-offset-arg-required">;
def : ClFlag<"intel-buffer-offset-arg-required">,
  Alias<buffer_offset_arg_required>;

def has_positive_pointer_offset : ZeFlag<"opt-has-positive-pointer-offset">;
def : ClFlag<"intel-has-positive-pointer-offset">,
  Alias<has_positive_pointer_offset>;

def has_subdw_aligned_ptr_arg : ZeFlag<"opt-has-subDW-aligned-ptr-arg">;
def : ClFlag<"intel-has-subDW-aligned-ptr-arg">,
  Alias<has_subdw_aligned_ptr_arg>;

defm intel_disable_a64wa : CommonFlag<"intel-disable-a64WA">;
defm intel_force_enable_a64wa : CommonFlag<"intel-force-enable-a64WA">;

defm intel_gtpin_rera : CommonFlag<"intel-gtpin-rera">;

defm intel_enable_prera_scheduling : CommonFlag<"intel-no-prera-scheduling">;

defm intel_use_bindless_buffers : CommonFlag<"intel-use-bindless-buffers">;

defm intel_use_bindless_images : CommonFlag<"intel-use-bindless-images">;

defm intel_use_bindless_mode : CommonFlag<"intel-use-bindless-mode">;

defm intel_use_bindless_printf : CommonFlag<"intel-use-bindless-printf">;

defm intel_force_global_mem_allocation :
  CommonFlag<"intel-force-global-mem-allocation">;
defm intel_no_local_to_generic : CommonFlag<"intel-no-local-to-generic">;

defm intel_vector_coalescing : CommonJoined<"intel-vector-coalesing=">;

defm allow_zebin : CommonFlag<"allow-zebin">;

defm intel_no_spill : CommonFlag<"intel-no-spill">;
// }} Backend internal options

// Internal options from source translation {{
def oclfe_ocl_version : PlainJoined<"ocl-version=">;

def oclfe_force_cl_std : PlainFlag<"force-cl-std">;

def oclfe_32bit : PlainFlag<"m32">;

def oclfe_64bit : PlainFlag<"m64">;

def oclfe_D : PlainJoinedOrSeparate<"D">;

def oclfe_cl_ext : ClJoined<"ext=">;
// }} Internal options from source translation

}
// }} IGC internal options

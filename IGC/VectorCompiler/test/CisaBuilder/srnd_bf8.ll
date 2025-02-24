;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2025 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; COM: ;;;;;;;;;; RUNNERS ;;;;;;;;;;

; REQUIRES: llvm_12_or_greater
; RUN: %llc_typed_ptrs %s -march=genx64 -mcpu=Xe3 -vc-skip-ocl-runtime-info -finalizer-opts='-dumpcommonisa -isaasmToConsole' -o /dev/null \
; RUN: | FileCheck %s
; RUN: %llc_opaque_ptrs %s -march=genx64 -mcpu=Xe3 -vc-skip-ocl-runtime-info -finalizer-opts='-dumpcommonisa -isaasmToConsole' -o /dev/null \
; RUN: | FileCheck %s

; COM: ;;;;;;;;;; CHECKERS ;;;;;;;;;;

; CHECK: .decl [[SRC0_HF:V[^ ]+]] v_type=G type=hf num_elts=16
; CHECK: .decl [[DST_HF:V[^ ]+]] v_type=G type=ub num_elts=16 alias
; CHECK: .decl [[SRC1:V[^ ]+]] v_type=G type=ub num_elts=16 alias

; CHECK: srnd (M1_NM, 16) [[DST_HF]](0,0)<1> [[SRC0_HF]](0,0)<1;1,0> [[SRC1]](0,0)<1;1,0>

; COM: ;;;;;;;;;; KERNEL ;;;;;;;;;;

target datalayout = "e-p:64:64-i64:64-n8:16:32"
target triple = "genx64-unknown-unknown"

declare <16 x i8> @llvm.vc.internal.stochastic.round.to.bf8.v16i8.v16f16.v16i8(<16 x half>, <16 x i8>)

define dllexport spir_kernel void @srnd_bf8_Kernel_out(i64 %buffer) local_unnamed_addr #0 {
  %pf16 = inttoptr i64 %buffer to <16 x half> addrspace(1)*
  %pnext = getelementptr <16 x half>, <16 x half> addrspace(1)* %pf16, i32 1

  %pi8 = bitcast <16 x half> addrspace(1)* %pnext to <16 x i8> addrspace(1)*

  %f16 = load <16 x half>, <16 x half> addrspace(1)* %pf16

  %rnd = load <16 x i8>, <16 x i8> addrspace(1)* %pi8

  %a = call <16 x i8> @llvm.vc.internal.stochastic.round.to.bf8.v16i8.v16f16.v16i8(<16 x half> %f16, <16 x i8> %rnd)

  %pa = inttoptr i64 %buffer to <16 x i8> addrspace(1)*
  %prnd = getelementptr <16 x i8>, <16 x i8> addrspace(1)* %pa, i32 2

  store <16 x i8> %a, <16 x i8> addrspace(1)* %pa
  store <16 x i8> %rnd, <16 x i8> addrspace(1)* %prnd

  ret void
}

attributes #0 = { noinline nounwind "CMGenxMain" }

!spirv.Source = !{!1}
!opencl.spir.version = !{!2}
!opencl.ocl.version = !{!1}
!opencl.used.extensions = !{!0}
!opencl.used.optional.core.features = !{!0}
!spirv.Generator = !{!3}
!genx.kernels = !{!4}
!genx.kernel.internal = !{!8}

!0 = !{}
!1 = !{i32 0}
!2 = !{i32 1, i32 2}
!3 = !{i16 6, i16 14}
!4 = !{void (i64)* @srnd_bf8_Kernel_out, !"srnd_bf8_Kernel_out", !5, i32 0, !6, !1, !7, i32 0}
!5 = !{i32 0}
!6 = !{i32 64}
!7 = !{!"svmptr_t"}
!8 = !{void (i64)* @srnd_bf8_Kernel_out, null, null, null, null}

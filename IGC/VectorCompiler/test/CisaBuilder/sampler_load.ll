;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2024 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; RUN: %opt_typed_ptrs %use_old_pass_manager% -march=genx64 -mtriple=spir64-unknown-unknown -mcpu=XeLP \
; RUN: -GenXModule -GenXCategoryWrapper -GenXCisaBuilderPass -GenXFinalizer \
; RUN: -finalizer-opts="-dumpcommonisa -isaasmToConsole" < %s -o /dev/null | FileCheck %s
; RUN: %opt_opaque_ptrs %use_old_pass_manager% -march=genx64 -mtriple=spir64-unknown-unknown -mcpu=XeLP \
; RUN: -GenXModule -GenXCategoryWrapper -GenXCisaBuilderPass -GenXFinalizer \
; RUN: -finalizer-opts="-dumpcommonisa -isaasmToConsole" < %s -o /dev/null | FileCheck %s

declare <64 x float> @llvm.vc.internal.sampler.load.bti.v64f32.v16i1.v16i32(<16 x i1>, i16, i8, i16, i32, <64 x float>, <16 x i32>, <16 x i32>, <16 x i32>, <16 x i32>, <16 x i32>, <16 x i32>, <16 x i32>, <16 x i32>, <16 x i32>)

; CHECK-LABEL: .kernel "test"
; CHECK: .decl [[U:V[0-9]+]] v_type=G type=d num_elts=16 align=GRF
; CHECK: .decl [[V:V[0-9]+]] v_type=G type=d num_elts=16 align=GRF
; CHECK: .decl [[DST:V[0-9]+]] v_type=G type=f num_elts=64 align=GRF
; CHECK: .input [[U]] offset=64 size=64
; CHECK: .input [[V]] offset=128 size=64

define dllexport spir_kernel void @test(i32 %surf, <16 x i32> %u, <16 x i32> %v) #0 {
; CHECK: movs (M1, 1) [[BTI:T[0-9]+]](0) 0x7b:ud
; CHECK: load_3d.RGBA (M1, 16) 0x0:uw [[BTI]] [[DST]].0 %null.0 [[U]].0 [[V]].0
; CHECK: load_lz.RGBA (M1, 16) 0x0:uw [[BTI]] [[DST]].0 %null.0 [[U]].0 [[V]].0
  %1 = call <64 x float> @llvm.vc.internal.sampler.load.bti.v64f32.v16i1.v16i32(<16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, i16 7, i8 15, i16 0, i32 123, <64 x float> undef, <16 x i32> %u, <16 x i32> %v, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef)
  %2 = call <64 x float> @llvm.vc.internal.sampler.load.bti.v64f32.v16i1.v16i32(<16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, i16 26, i8 15, i16 0, i32 123, <64 x float> %1, <16 x i32> %u, <16 x i32> %v, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef, <16 x i32> undef)
  ret void
}

attributes #0 = { "CMGenxMain" "VC.Stack.Amount"="0" "target-cpu"="XeLP" }

!genx.kernels = !{!0}
!genx.kernel.internal = !{!5}

!0 = !{void (i32, <16 x i32>, <16 x i32>)* @test, !"test", !1, i32 0, !2, !3, !4, i32 0}
!1 = !{i32 0, i32 0, i32 0}
!2 = !{i32 32, i32 64, i32 128}
!3 = !{i32 0, i32 0, i32 0}
!4 = !{!"image2d_t read_write", !"", !""}
!5 = !{void (i32, <16 x i32>, <16 x i32>)* @test, null, null, null, null}

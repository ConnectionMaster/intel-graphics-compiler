;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2022-2024 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================


; REQUIRES: llvm-14-plus
; RUN: igc_opt --opaque-pointers --igc-vectorpreprocess -S < %s | FileCheck %s
; ------------------------------------------------
; VectorPreProcess : store unaligned
; ------------------------------------------------
; This test checks that VectorPreProcess pass follows
; 'How to Update Debug Info' llvm guideline.

; Debug MD for this test was created with debugify pass.
; ------------------------------------------------

; CHECK:  spir_kernel void @test_vecpre
; CHECK-SAME: !dbg [[SCOPE:![0-9]*]]

; CHECK: store{{.*}} [[STORE1_LOC:![0-9]*]]
; CHECK: call{{.*}}store{{.*}} [[STORE2_LOC:![0-9]*]]

define spir_kernel void @test_vecpre(<4 x float> addrspace(1)* %a, float %b) !dbg !6 {
  %1 = fadd float %b, 1.000000e+00, !dbg !17
  call void @llvm.dbg.value(metadata float %1, metadata !9, metadata !DIExpression()), !dbg !17
  %2 = fadd float %b, 2.000000e+00, !dbg !18
  call void @llvm.dbg.value(metadata float %2, metadata !11, metadata !DIExpression()), !dbg !18
  %3 = fadd float %b, 3.000000e+00, !dbg !19
  call void @llvm.dbg.value(metadata float %3, metadata !12, metadata !DIExpression()), !dbg !19
  %4 = insertelement <4 x float> undef, float %1, i32 0, !dbg !20
  call void @llvm.dbg.value(metadata <4 x float> %4, metadata !13, metadata !DIExpression()), !dbg !20
  %5 = insertelement <4 x float> %4, float %2, i32 1, !dbg !21
  call void @llvm.dbg.value(metadata <4 x float> %5, metadata !15, metadata !DIExpression()), !dbg !21
  %6 = insertelement <4 x float> %5, float %1, i32 1, !dbg !22
  call void @llvm.dbg.value(metadata <4 x float> %6, metadata !16, metadata !DIExpression()), !dbg !22
  store <4 x float> %6, <4 x float> addrspace(1)* %a, align 1, !dbg !23
  call void @llvm.genx.GenISA.storerawvector_indexed.p1v4f32(<4 x float> addrspace(1)* %a, i32 4, <4 x float> <float 1.000000e+00, float 2.000000e+00, float 3.000000e+00, float undef>, i32 1, i1 false), !dbg !24
  ret void, !dbg !25
}
; CHECK-DAG: [[FILE:![0-9]*]] = !DIFile(filename: "store.ll", directory: "/")
; CHECK-DAG: [[SCOPE]] = distinct !DISubprogram(name: "test_vecpre", linkageName: "test_vecpre", scope: null, file: [[FILE]], line: 1
; CHECK-DAG: [[STORE1_LOC]] = !DILocation(line: 7, column: 1, scope: [[SCOPE]])
; CHECK-DAG: [[STORE2_LOC]] = !DILocation(line: 8, column: 1, scope: [[SCOPE]])

declare void @llvm.genx.GenISA.storerawvector_indexed.p1v4f32(<4 x float> addrspace(1)*, i32, <4 x float>, i32, i1)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #0

attributes #0 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.debugify = !{!3, !4}
!llvm.module.flags = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "debugify", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "store.ll", directory: "/")
!2 = !{}
!3 = !{i32 9}
!4 = !{i32 6}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = distinct !DISubprogram(name: "test_vecpre", linkageName: "test_vecpre", scope: null, file: !1, line: 1, type: !7, scopeLine: 1, unit: !0, retainedNodes: !8)
!7 = !DISubroutineType(types: !2)
!8 = !{!9, !11, !12, !13, !15, !16}
!9 = !DILocalVariable(name: "1", scope: !6, file: !1, line: 1, type: !10)
!10 = !DIBasicType(name: "ty32", size: 32, encoding: DW_ATE_unsigned)
!11 = !DILocalVariable(name: "2", scope: !6, file: !1, line: 2, type: !10)
!12 = !DILocalVariable(name: "3", scope: !6, file: !1, line: 3, type: !10)
!13 = !DILocalVariable(name: "4", scope: !6, file: !1, line: 4, type: !14)
!14 = !DIBasicType(name: "ty128", size: 128, encoding: DW_ATE_unsigned)
!15 = !DILocalVariable(name: "5", scope: !6, file: !1, line: 5, type: !14)
!16 = !DILocalVariable(name: "6", scope: !6, file: !1, line: 6, type: !14)
!17 = !DILocation(line: 1, column: 1, scope: !6)
!18 = !DILocation(line: 2, column: 1, scope: !6)
!19 = !DILocation(line: 3, column: 1, scope: !6)
!20 = !DILocation(line: 4, column: 1, scope: !6)
!21 = !DILocation(line: 5, column: 1, scope: !6)
!22 = !DILocation(line: 6, column: 1, scope: !6)
!23 = !DILocation(line: 7, column: 1, scope: !6)
!24 = !DILocation(line: 8, column: 1, scope: !6)
!25 = !DILocation(line: 9, column: 1, scope: !6)

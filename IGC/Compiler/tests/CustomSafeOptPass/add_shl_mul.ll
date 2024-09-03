;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2024 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================
;
; RUN: igc_opt -igc-custom-safe-opt -S < %s | FileCheck %s

; CustomSafeOpt will try to move emulated addition with constant, from
;
; %1 = shl i32 %a, 4
; %2 = or  i32 %1, 14
; %3 = add i32 %2, %b
;
; to
;
; %1 = shl i32 %a, 4
; %2 = add i32 %1, %b
; %3 = add i32 %2, 14

define i32 @test_customsafe_shl(i32 %a, i32 %b) {
; CHECK-LABEL: @test_customsafe_shl(
; CHECK:    [[TMP1:%.*]] = shl i32 [[A:%.*]], 4
; CHECK:    [[TMP2:%.*]] = add i32 [[TMP1]], [[B:%.*]]
; CHECK:    [[TMP3:%.*]] = add i32 [[TMP2]], 14
; CHECK:    ret i32 [[TMP3]]
;
  %1 = shl i32 %a, 4
  %2 = or  i32 %1, 14
  %3 = add i32 %2, %b
  ret i32 %3
}

; Or with multiplication
;
;  %1 = mul nuw i64 %a, 6
;  %2 = or  i64 %1, 1
;  %3 = add nuw i64 %2, %b
;
; to
;
;  %1 = mul nuw i64 %a, 6
;  %2 = add i64 %1, %b
;  %3 = add i64 %2, 1

define i64 @test_customsafe_mul(i64 %a, i64 %b) {
; CHECK-LABEL: @test_customsafe_mul(
; CHECK:    [[TMP1:%.*]] = mul nuw i64 [[A:%.*]], 6
; CHECK:    [[TMP2:%.*]] = add i64 [[TMP1]], [[B:%.*]]
; CHECK:    [[TMP3:%.*]] = add i64 [[TMP2]], 1
; CHECK:    ret i64 [[TMP3]]
;
  %1 = mul nuw i64 %a, 6
  %2 = or  i64 %1, 1
  %3 = add nuw i64 %2, %b
  ret i64 %3
}

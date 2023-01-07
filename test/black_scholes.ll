; ModuleID = 'test/black_scholes.cc'
source_filename = "test/black_scholes.cc"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external hidden global i8
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @_GLOBAL__sub_I_black_scholes.cc, ptr null }]

; Function Attrs: noinline uwtable
define internal void @__cxx_global_var_init() #0 section ".text.startup" {
  call void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1) @_ZStL8__ioinit)
  %1 = call i32 @__cxa_atexit(ptr @_ZNSt8ios_base4InitD1Ev, ptr @_ZStL8__ioinit, ptr @__dso_handle) #3
  ret void
}

declare void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #1

; Function Attrs: nounwind
declare void @_ZNSt8ios_base4InitD1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #2

; Function Attrs: nounwind
declare i32 @__cxa_atexit(ptr, ptr, ptr) #3

; Function Attrs: mustprogress noinline nounwind uwtable
define dso_local noundef double @_Z8norm_pdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %0) #4 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = call double @pow(double noundef 0x401921FB54442D18, double noundef 5.000000e-01) #3
  %4 = fdiv double 1.000000e+00, %3
  %5 = load ptr, ptr %2, align 8
  %6 = load double, ptr %5, align 8
  %7 = fmul double -5.000000e-01, %6
  %8 = load ptr, ptr %2, align 8
  %9 = load double, ptr %8, align 8
  %10 = fmul double %7, %9
  %11 = call double @exp(double noundef %10) #3
  %12 = fmul double %4, %11
  ret double %12
}

; Function Attrs: nounwind
declare double @pow(double noundef, double noundef) #2

; Function Attrs: nounwind
declare double @exp(double noundef) #2

; Function Attrs: mustprogress noinline uwtable
define dso_local noundef double @_Z8norm_cdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %0) #5 {
  %2 = alloca double, align 8
  %3 = alloca ptr, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  store ptr %0, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  %8 = load double, ptr %7, align 8
  %9 = call double @llvm.fmuladd.f64(double 0x3FCDA6711871100E, double %8, double 1.000000e+00)
  %10 = fdiv double 1.000000e+00, %9
  store double %10, ptr %4, align 8
  %11 = load double, ptr %4, align 8
  %12 = load double, ptr %4, align 8
  %13 = load double, ptr %4, align 8
  %14 = load double, ptr %4, align 8
  %15 = load double, ptr %4, align 8
  %16 = call double @llvm.fmuladd.f64(double 0x3FF548CDD6F42943, double %15, double 0xBFFD23DD4EF278D0)
  %17 = call double @llvm.fmuladd.f64(double %14, double %16, double 0x3FFC80EF025F5E68)
  %18 = call double @llvm.fmuladd.f64(double %13, double %17, double 0xBFD6D1F0E5A8325B)
  %19 = call double @llvm.fmuladd.f64(double %12, double %18, double 0x3FD470BF3A92F8EC)
  %20 = fmul double %11, %19
  store double %20, ptr %5, align 8
  %21 = load ptr, ptr %3, align 8
  %22 = load double, ptr %21, align 8
  %23 = fcmp oge double %22, 0.000000e+00
  br i1 %23, label %24, label %38

24:                                               ; preds = %1
  %25 = call double @pow(double noundef 0x401921FB54442D18, double noundef 5.000000e-01) #3
  %26 = fdiv double 1.000000e+00, %25
  %27 = load ptr, ptr %3, align 8
  %28 = load double, ptr %27, align 8
  %29 = fmul double -5.000000e-01, %28
  %30 = load ptr, ptr %3, align 8
  %31 = load double, ptr %30, align 8
  %32 = fmul double %29, %31
  %33 = call double @exp(double noundef %32) #3
  %34 = fmul double %26, %33
  %35 = load double, ptr %5, align 8
  %36 = fneg double %34
  %37 = call double @llvm.fmuladd.f64(double %36, double %35, double 1.000000e+00)
  store double %37, ptr %2, align 8
  br label %44

38:                                               ; preds = %1
  %39 = load ptr, ptr %3, align 8
  %40 = load double, ptr %39, align 8
  %41 = fneg double %40
  store double %41, ptr %6, align 8
  %42 = call noundef double @_Z8norm_cdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %6)
  %43 = fsub double 1.000000e+00, %42
  store double %43, ptr %2, align 8
  br label %44

44:                                               ; preds = %38, %24
  %45 = load double, ptr %2, align 8
  ret double %45
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: mustprogress noinline nounwind uwtable
define dso_local noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %0, ptr noundef nonnull align 8 dereferenceable(8) %1, ptr noundef nonnull align 8 dereferenceable(8) %2, ptr noundef nonnull align 8 dereferenceable(8) %3, ptr noundef nonnull align 8 dereferenceable(8) %4, ptr noundef nonnull align 8 dereferenceable(8) %5) #4 {
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  store ptr %0, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store ptr %2, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store ptr %4, ptr %11, align 8
  store ptr %5, ptr %12, align 8
  %13 = load ptr, ptr %8, align 8
  %14 = load double, ptr %13, align 8
  %15 = load ptr, ptr %9, align 8
  %16 = load double, ptr %15, align 8
  %17 = fdiv double %14, %16
  %18 = call double @log(double noundef %17) #3
  %19 = load ptr, ptr %10, align 8
  %20 = load double, ptr %19, align 8
  %21 = load ptr, ptr %7, align 8
  %22 = load i32, ptr %21, align 4
  %23 = sub nsw i32 %22, 1
  %24 = sitofp i32 %23 to double
  %25 = call double @pow(double noundef -1.000000e+00, double noundef %24) #3
  %26 = fmul double %25, 5.000000e-01
  %27 = load ptr, ptr %11, align 8
  %28 = load double, ptr %27, align 8
  %29 = fmul double %26, %28
  %30 = load ptr, ptr %11, align 8
  %31 = load double, ptr %30, align 8
  %32 = call double @llvm.fmuladd.f64(double %29, double %31, double %20)
  %33 = load ptr, ptr %12, align 8
  %34 = load double, ptr %33, align 8
  %35 = call double @llvm.fmuladd.f64(double %32, double %34, double %18)
  %36 = load ptr, ptr %11, align 8
  %37 = load double, ptr %36, align 8
  %38 = load ptr, ptr %12, align 8
  %39 = load double, ptr %38, align 8
  %40 = call double @pow(double noundef %39, double noundef 5.000000e-01) #3
  %41 = fmul double %37, %40
  %42 = fdiv double %35, %41
  ret double %42
}

; Function Attrs: nounwind
declare double @log(double noundef) #2

; Function Attrs: mustprogress noinline uwtable
define dso_local noundef double @_Z10call_priceRKdS0_S0_S0_S0_(ptr noundef nonnull align 8 dereferenceable(8) %0, ptr noundef nonnull align 8 dereferenceable(8) %1, ptr noundef nonnull align 8 dereferenceable(8) %2, ptr noundef nonnull align 8 dereferenceable(8) %3, ptr noundef nonnull align 8 dereferenceable(8) %4) #5 {
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  %13 = alloca double, align 8
  %14 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store ptr %1, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store ptr %3, ptr %9, align 8
  store ptr %4, ptr %10, align 8
  %15 = load ptr, ptr %6, align 8
  %16 = load double, ptr %15, align 8
  store i32 1, ptr %12, align 4
  %17 = load ptr, ptr %6, align 8
  %18 = load ptr, ptr %7, align 8
  %19 = load ptr, ptr %8, align 8
  %20 = load ptr, ptr %9, align 8
  %21 = load ptr, ptr %10, align 8
  %22 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %12, ptr noundef nonnull align 8 dereferenceable(8) %17, ptr noundef nonnull align 8 dereferenceable(8) %18, ptr noundef nonnull align 8 dereferenceable(8) %19, ptr noundef nonnull align 8 dereferenceable(8) %20, ptr noundef nonnull align 8 dereferenceable(8) %21)
  store double %22, ptr %11, align 8
  %23 = call noundef double @_Z8norm_cdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %11)
  %24 = load ptr, ptr %7, align 8
  %25 = load double, ptr %24, align 8
  %26 = load ptr, ptr %8, align 8
  %27 = load double, ptr %26, align 8
  %28 = fneg double %27
  %29 = load ptr, ptr %10, align 8
  %30 = load double, ptr %29, align 8
  %31 = fmul double %28, %30
  %32 = call double @exp(double noundef %31) #3
  %33 = fmul double %25, %32
  store i32 2, ptr %14, align 4
  %34 = load ptr, ptr %6, align 8
  %35 = load ptr, ptr %7, align 8
  %36 = load ptr, ptr %8, align 8
  %37 = load ptr, ptr %9, align 8
  %38 = load ptr, ptr %10, align 8
  %39 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %14, ptr noundef nonnull align 8 dereferenceable(8) %34, ptr noundef nonnull align 8 dereferenceable(8) %35, ptr noundef nonnull align 8 dereferenceable(8) %36, ptr noundef nonnull align 8 dereferenceable(8) %37, ptr noundef nonnull align 8 dereferenceable(8) %38)
  store double %39, ptr %13, align 8
  %40 = call noundef double @_Z8norm_cdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %13)
  %41 = fmul double %33, %40
  %42 = fneg double %41
  %43 = call double @llvm.fmuladd.f64(double %16, double %23, double %42)
  ret double %43
}

; Function Attrs: mustprogress noinline uwtable
define dso_local noundef double @_Z9put_priceRKdS0_S0_S0_S0_(ptr noundef nonnull align 8 dereferenceable(8) %0, ptr noundef nonnull align 8 dereferenceable(8) %1, ptr noundef nonnull align 8 dereferenceable(8) %2, ptr noundef nonnull align 8 dereferenceable(8) %3, ptr noundef nonnull align 8 dereferenceable(8) %4) #5 {
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  %13 = alloca double, align 8
  %14 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store ptr %1, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store ptr %3, ptr %9, align 8
  store ptr %4, ptr %10, align 8
  %15 = load ptr, ptr %6, align 8
  %16 = load double, ptr %15, align 8
  %17 = fneg double %16
  store i32 1, ptr %12, align 4
  %18 = load ptr, ptr %6, align 8
  %19 = load ptr, ptr %7, align 8
  %20 = load ptr, ptr %8, align 8
  %21 = load ptr, ptr %9, align 8
  %22 = load ptr, ptr %10, align 8
  %23 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %12, ptr noundef nonnull align 8 dereferenceable(8) %18, ptr noundef nonnull align 8 dereferenceable(8) %19, ptr noundef nonnull align 8 dereferenceable(8) %20, ptr noundef nonnull align 8 dereferenceable(8) %21, ptr noundef nonnull align 8 dereferenceable(8) %22)
  %24 = fneg double %23
  store double %24, ptr %11, align 8
  %25 = call noundef double @_Z8norm_cdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %11)
  %26 = load ptr, ptr %7, align 8
  %27 = load double, ptr %26, align 8
  %28 = load ptr, ptr %8, align 8
  %29 = load double, ptr %28, align 8
  %30 = fneg double %29
  %31 = load ptr, ptr %10, align 8
  %32 = load double, ptr %31, align 8
  %33 = fmul double %30, %32
  %34 = call double @exp(double noundef %33) #3
  %35 = fmul double %27, %34
  store i32 2, ptr %14, align 4
  %36 = load ptr, ptr %6, align 8
  %37 = load ptr, ptr %7, align 8
  %38 = load ptr, ptr %8, align 8
  %39 = load ptr, ptr %9, align 8
  %40 = load ptr, ptr %10, align 8
  %41 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %14, ptr noundef nonnull align 8 dereferenceable(8) %36, ptr noundef nonnull align 8 dereferenceable(8) %37, ptr noundef nonnull align 8 dereferenceable(8) %38, ptr noundef nonnull align 8 dereferenceable(8) %39, ptr noundef nonnull align 8 dereferenceable(8) %40)
  %42 = fneg double %41
  store double %42, ptr %13, align 8
  %43 = call noundef double @_Z8norm_cdfRKd(ptr noundef nonnull align 8 dereferenceable(8) %13)
  %44 = fmul double %35, %43
  %45 = call double @llvm.fmuladd.f64(double %17, double %25, double %44)
  ret double %45
}

; Function Attrs: mustprogress noinline norecurse uwtable
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef %1) #7 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca i32, align 4
  %12 = alloca double, align 8
  %13 = alloca double, align 8
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  store double 1.000000e+02, ptr %6, align 8
  store double 1.000000e+02, ptr %7, align 8
  store double 5.000000e-02, ptr %8, align 8
  store double 2.000000e-01, ptr %9, align 8
  store double 1.000000e+00, ptr %10, align 8
  store i32 0, ptr %11, align 4
  br label %14

14:                                               ; preds = %20, %2
  %15 = load i32, ptr %11, align 4
  %16 = icmp slt i32 %15, 200
  br i1 %16, label %17, label %23

17:                                               ; preds = %14
  %18 = call noundef double @_Z10call_priceRKdS0_S0_S0_S0_(ptr noundef nonnull align 8 dereferenceable(8) %6, ptr noundef nonnull align 8 dereferenceable(8) %7, ptr noundef nonnull align 8 dereferenceable(8) %8, ptr noundef nonnull align 8 dereferenceable(8) %9, ptr noundef nonnull align 8 dereferenceable(8) %10)
  store double %18, ptr %12, align 8
  %19 = call noundef double @_Z9put_priceRKdS0_S0_S0_S0_(ptr noundef nonnull align 8 dereferenceable(8) %6, ptr noundef nonnull align 8 dereferenceable(8) %7, ptr noundef nonnull align 8 dereferenceable(8) %8, ptr noundef nonnull align 8 dereferenceable(8) %9, ptr noundef nonnull align 8 dereferenceable(8) %10)
  store double %19, ptr %13, align 8
  br label %20

20:                                               ; preds = %17
  %21 = load i32, ptr %11, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %11, align 4
  br label %14, !llvm.loop !6

23:                                               ; preds = %14
  ret i32 0
}

; Function Attrs: noinline uwtable
define internal void @_GLOBAL__sub_I_black_scholes.cc() #0 section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { noinline uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { mustprogress noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress noinline uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #7 = { mustprogress noinline norecurse uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 15.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}

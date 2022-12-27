; ModuleID = 'test/black_scholes.cc'
source_filename = "test/black_scholes.cc"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%"class.std::basic_ostream" = type { i32 (...)**, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", %"class.std::basic_ostream"*, i8, i8, %"class.std::basic_streambuf"*, %"class.std::ctype"*, %"class.std::num_put"*, %"class.std::num_get"* }
%"class.std::ios_base" = type { i32 (...)**, i64, i64, i32, i32, i32, %"struct.std::ios_base::_Callback_list"*, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, %"struct.std::ios_base::_Words"*, %"class.std::locale" }
%"struct.std::ios_base::_Callback_list" = type { %"struct.std::ios_base::_Callback_list"*, void (i32, %"class.std::ios_base"*, i32)*, i32, i32 }
%"struct.std::ios_base::_Words" = type { i8*, i64 }
%"class.std::locale" = type { %"class.std::locale::_Impl"* }
%"class.std::locale::_Impl" = type { i32, %"class.std::locale::facet"**, i64, %"class.std::locale::facet"**, i8** }
%"class.std::locale::facet" = type <{ i32 (...)**, i32, [4 x i8] }>
%"class.std::basic_streambuf" = type { i32 (...)**, i8*, i8*, i8*, i8*, i8*, i8*, %"class.std::locale" }
%"class.std::ctype" = type <{ %"class.std::locale::facet.base", [4 x i8], %struct.__locale_struct*, i8, [7 x i8], i32*, i32*, i16*, i8, [256 x i8], [256 x i8], i8, [6 x i8] }>
%"class.std::locale::facet.base" = type <{ i32 (...)**, i32 }>
%struct.__locale_struct = type { [13 x %struct.__locale_data*], i16*, i32*, i32*, [13 x i8*] }
%struct.__locale_data = type opaque
%"class.std::num_put" = type { %"class.std::locale::facet.base", [4 x i8] }
%"class.std::num_get" = type { %"class.std::locale::facet.base", [4 x i8] }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external hidden global i8
@_ZSt4cout = external global %"class.std::basic_ostream", align 8
@.str = private unnamed_addr constant [18 x i8] c"Underlying:      \00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Strike:          \00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"Risk-Free Rate:  \00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"Volatility:      \00", align 1
@.str.4 = private unnamed_addr constant [18 x i8] c"Maturity:        \00", align 1
@.str.5 = private unnamed_addr constant [18 x i8] c"Call Price:      \00", align 1
@.str.6 = private unnamed_addr constant [18 x i8] c"Put Price:       \00", align 1
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_black_scholes.cc, i8* null }]

; Function Attrs: noinline uwtable
define internal void @__cxx_global_var_init() #0 section ".text.startup" {
  call void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"* noundef nonnull align 1 dereferenceable(1) @_ZStL8__ioinit)
  %1 = call i32 @__cxa_atexit(void (i8*)* bitcast (void (%"class.std::ios_base::Init"*)* @_ZNSt8ios_base4InitD1Ev to void (i8*)*), i8* getelementptr inbounds (%"class.std::ios_base::Init", %"class.std::ios_base::Init"* @_ZStL8__ioinit, i32 0, i32 0), i8* @__dso_handle) #3
  ret void
}

declare void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"* noundef nonnull align 1 dereferenceable(1)) unnamed_addr #1

; Function Attrs: nounwind
declare void @_ZNSt8ios_base4InitD1Ev(%"class.std::ios_base::Init"* noundef nonnull align 1 dereferenceable(1)) unnamed_addr #2

; Function Attrs: nounwind
declare i32 @__cxa_atexit(void (i8*)*, i8*, i8*) #3

; Function Attrs: mustprogress noinline nounwind uwtable
define dso_local noundef double @_Z8norm_pdfRKd(double* noundef nonnull align 8 dereferenceable(8) %0) #4 {
  %2 = alloca double*, align 8
  store double* %0, double** %2, align 8
  %3 = call double @pow(double noundef 0x401921FB54442D18, double noundef 5.000000e-01) #3
  %4 = fdiv double 1.000000e+00, %3
  %5 = load double*, double** %2, align 8
  %6 = load double, double* %5, align 8
  %7 = fmul double -5.000000e-01, %6
  %8 = load double*, double** %2, align 8
  %9 = load double, double* %8, align 8
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
define dso_local noundef double @_Z8norm_cdfRKd(double* noundef nonnull align 8 dereferenceable(8) %0) #5 {
  %2 = alloca double, align 8
  %3 = alloca double*, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  store double* %0, double** %3, align 8
  %7 = load double*, double** %3, align 8
  %8 = load double, double* %7, align 8
  %9 = call double @llvm.fmuladd.f64(double 0x3FCDA6711871100E, double %8, double 1.000000e+00)
  %10 = fdiv double 1.000000e+00, %9
  store double %10, double* %4, align 8
  %11 = load double, double* %4, align 8
  %12 = load double, double* %4, align 8
  %13 = load double, double* %4, align 8
  %14 = load double, double* %4, align 8
  %15 = load double, double* %4, align 8
  %16 = call double @llvm.fmuladd.f64(double 0x3FF548CDD6F42943, double %15, double 0xBFFD23DD4EF278D0)
  %17 = call double @llvm.fmuladd.f64(double %14, double %16, double 0x3FFC80EF025F5E68)
  %18 = call double @llvm.fmuladd.f64(double %13, double %17, double 0xBFD6D1F0E5A8325B)
  %19 = call double @llvm.fmuladd.f64(double %12, double %18, double 0x3FD470BF3A92F8EC)
  %20 = fmul double %11, %19
  store double %20, double* %5, align 8
  %21 = load double*, double** %3, align 8
  %22 = load double, double* %21, align 8
  %23 = fcmp oge double %22, 0.000000e+00
  br i1 %23, label %24, label %38

24:                                               ; preds = %1
  %25 = call double @pow(double noundef 0x401921FB54442D18, double noundef 5.000000e-01) #3
  %26 = fdiv double 1.000000e+00, %25
  %27 = load double*, double** %3, align 8
  %28 = load double, double* %27, align 8
  %29 = fmul double -5.000000e-01, %28
  %30 = load double*, double** %3, align 8
  %31 = load double, double* %30, align 8
  %32 = fmul double %29, %31
  %33 = call double @exp(double noundef %32) #3
  %34 = fmul double %26, %33
  %35 = load double, double* %5, align 8
  %36 = fneg double %34
  %37 = call double @llvm.fmuladd.f64(double %36, double %35, double 1.000000e+00)
  store double %37, double* %2, align 8
  br label %44

38:                                               ; preds = %1
  %39 = load double*, double** %3, align 8
  %40 = load double, double* %39, align 8
  %41 = fneg double %40
  store double %41, double* %6, align 8
  %42 = call noundef double @_Z8norm_cdfRKd(double* noundef nonnull align 8 dereferenceable(8) %6)
  %43 = fsub double 1.000000e+00, %42
  store double %43, double* %2, align 8
  br label %44

44:                                               ; preds = %38, %24
  %45 = load double, double* %2, align 8
  ret double %45
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: mustprogress noinline nounwind uwtable
define dso_local noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(i32* noundef nonnull align 4 dereferenceable(4) %0, double* noundef nonnull align 8 dereferenceable(8) %1, double* noundef nonnull align 8 dereferenceable(8) %2, double* noundef nonnull align 8 dereferenceable(8) %3, double* noundef nonnull align 8 dereferenceable(8) %4, double* noundef nonnull align 8 dereferenceable(8) %5) #4 {
  %7 = alloca i32*, align 8
  %8 = alloca double*, align 8
  %9 = alloca double*, align 8
  %10 = alloca double*, align 8
  %11 = alloca double*, align 8
  %12 = alloca double*, align 8
  store i32* %0, i32** %7, align 8
  store double* %1, double** %8, align 8
  store double* %2, double** %9, align 8
  store double* %3, double** %10, align 8
  store double* %4, double** %11, align 8
  store double* %5, double** %12, align 8
  %13 = load double*, double** %8, align 8
  %14 = load double, double* %13, align 8
  %15 = load double*, double** %9, align 8
  %16 = load double, double* %15, align 8
  %17 = fdiv double %14, %16
  %18 = call double @log(double noundef %17) #3
  %19 = load double*, double** %10, align 8
  %20 = load double, double* %19, align 8
  %21 = load i32*, i32** %7, align 8
  %22 = load i32, i32* %21, align 4
  %23 = sub nsw i32 %22, 1
  %24 = sitofp i32 %23 to double
  %25 = call double @pow(double noundef -1.000000e+00, double noundef %24) #3
  %26 = fmul double %25, 5.000000e-01
  %27 = load double*, double** %11, align 8
  %28 = load double, double* %27, align 8
  %29 = fmul double %26, %28
  %30 = load double*, double** %11, align 8
  %31 = load double, double* %30, align 8
  %32 = call double @llvm.fmuladd.f64(double %29, double %31, double %20)
  %33 = load double*, double** %12, align 8
  %34 = load double, double* %33, align 8
  %35 = call double @llvm.fmuladd.f64(double %32, double %34, double %18)
  %36 = load double*, double** %11, align 8
  %37 = load double, double* %36, align 8
  %38 = load double*, double** %12, align 8
  %39 = load double, double* %38, align 8
  %40 = call double @pow(double noundef %39, double noundef 5.000000e-01) #3
  %41 = fmul double %37, %40
  %42 = fdiv double %35, %41
  ret double %42
}

; Function Attrs: nounwind
declare double @log(double noundef) #2

; Function Attrs: mustprogress noinline uwtable
define dso_local noundef double @_Z10call_priceRKdS0_S0_S0_S0_(double* noundef nonnull align 8 dereferenceable(8) %0, double* noundef nonnull align 8 dereferenceable(8) %1, double* noundef nonnull align 8 dereferenceable(8) %2, double* noundef nonnull align 8 dereferenceable(8) %3, double* noundef nonnull align 8 dereferenceable(8) %4) #5 {
  %6 = alloca double*, align 8
  %7 = alloca double*, align 8
  %8 = alloca double*, align 8
  %9 = alloca double*, align 8
  %10 = alloca double*, align 8
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  %13 = alloca double, align 8
  %14 = alloca i32, align 4
  store double* %0, double** %6, align 8
  store double* %1, double** %7, align 8
  store double* %2, double** %8, align 8
  store double* %3, double** %9, align 8
  store double* %4, double** %10, align 8
  %15 = load double*, double** %6, align 8
  %16 = load double, double* %15, align 8
  store i32 1, i32* %12, align 4
  %17 = load double*, double** %6, align 8
  %18 = load double*, double** %7, align 8
  %19 = load double*, double** %8, align 8
  %20 = load double*, double** %9, align 8
  %21 = load double*, double** %10, align 8
  %22 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(i32* noundef nonnull align 4 dereferenceable(4) %12, double* noundef nonnull align 8 dereferenceable(8) %17, double* noundef nonnull align 8 dereferenceable(8) %18, double* noundef nonnull align 8 dereferenceable(8) %19, double* noundef nonnull align 8 dereferenceable(8) %20, double* noundef nonnull align 8 dereferenceable(8) %21)
  store double %22, double* %11, align 8
  %23 = call noundef double @_Z8norm_cdfRKd(double* noundef nonnull align 8 dereferenceable(8) %11)
  %24 = load double*, double** %7, align 8
  %25 = load double, double* %24, align 8
  %26 = load double*, double** %8, align 8
  %27 = load double, double* %26, align 8
  %28 = fneg double %27
  %29 = load double*, double** %10, align 8
  %30 = load double, double* %29, align 8
  %31 = fmul double %28, %30
  %32 = call double @exp(double noundef %31) #3
  %33 = fmul double %25, %32
  store i32 2, i32* %14, align 4
  %34 = load double*, double** %6, align 8
  %35 = load double*, double** %7, align 8
  %36 = load double*, double** %8, align 8
  %37 = load double*, double** %9, align 8
  %38 = load double*, double** %10, align 8
  %39 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(i32* noundef nonnull align 4 dereferenceable(4) %14, double* noundef nonnull align 8 dereferenceable(8) %34, double* noundef nonnull align 8 dereferenceable(8) %35, double* noundef nonnull align 8 dereferenceable(8) %36, double* noundef nonnull align 8 dereferenceable(8) %37, double* noundef nonnull align 8 dereferenceable(8) %38)
  store double %39, double* %13, align 8
  %40 = call noundef double @_Z8norm_cdfRKd(double* noundef nonnull align 8 dereferenceable(8) %13)
  %41 = fmul double %33, %40
  %42 = fneg double %41
  %43 = call double @llvm.fmuladd.f64(double %16, double %23, double %42)
  ret double %43
}

; Function Attrs: mustprogress noinline uwtable
define dso_local noundef double @_Z9put_priceRKdS0_S0_S0_S0_(double* noundef nonnull align 8 dereferenceable(8) %0, double* noundef nonnull align 8 dereferenceable(8) %1, double* noundef nonnull align 8 dereferenceable(8) %2, double* noundef nonnull align 8 dereferenceable(8) %3, double* noundef nonnull align 8 dereferenceable(8) %4) #5 {
  %6 = alloca double*, align 8
  %7 = alloca double*, align 8
  %8 = alloca double*, align 8
  %9 = alloca double*, align 8
  %10 = alloca double*, align 8
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  %13 = alloca double, align 8
  %14 = alloca i32, align 4
  store double* %0, double** %6, align 8
  store double* %1, double** %7, align 8
  store double* %2, double** %8, align 8
  store double* %3, double** %9, align 8
  store double* %4, double** %10, align 8
  %15 = load double*, double** %6, align 8
  %16 = load double, double* %15, align 8
  %17 = fneg double %16
  store i32 1, i32* %12, align 4
  %18 = load double*, double** %6, align 8
  %19 = load double*, double** %7, align 8
  %20 = load double*, double** %8, align 8
  %21 = load double*, double** %9, align 8
  %22 = load double*, double** %10, align 8
  %23 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(i32* noundef nonnull align 4 dereferenceable(4) %12, double* noundef nonnull align 8 dereferenceable(8) %18, double* noundef nonnull align 8 dereferenceable(8) %19, double* noundef nonnull align 8 dereferenceable(8) %20, double* noundef nonnull align 8 dereferenceable(8) %21, double* noundef nonnull align 8 dereferenceable(8) %22)
  %24 = fneg double %23
  store double %24, double* %11, align 8
  %25 = call noundef double @_Z8norm_cdfRKd(double* noundef nonnull align 8 dereferenceable(8) %11)
  %26 = load double*, double** %7, align 8
  %27 = load double, double* %26, align 8
  %28 = load double*, double** %8, align 8
  %29 = load double, double* %28, align 8
  %30 = fneg double %29
  %31 = load double*, double** %10, align 8
  %32 = load double, double* %31, align 8
  %33 = fmul double %30, %32
  %34 = call double @exp(double noundef %33) #3
  %35 = fmul double %27, %34
  store i32 2, i32* %14, align 4
  %36 = load double*, double** %6, align 8
  %37 = load double*, double** %7, align 8
  %38 = load double*, double** %8, align 8
  %39 = load double*, double** %9, align 8
  %40 = load double*, double** %10, align 8
  %41 = call noundef double @_Z3d_jRKiRKdS2_S2_S2_S2_(i32* noundef nonnull align 4 dereferenceable(4) %14, double* noundef nonnull align 8 dereferenceable(8) %36, double* noundef nonnull align 8 dereferenceable(8) %37, double* noundef nonnull align 8 dereferenceable(8) %38, double* noundef nonnull align 8 dereferenceable(8) %39, double* noundef nonnull align 8 dereferenceable(8) %40)
  %42 = fneg double %41
  store double %42, double* %13, align 8
  %43 = call noundef double @_Z8norm_cdfRKd(double* noundef nonnull align 8 dereferenceable(8) %13)
  %44 = fmul double %35, %43
  %45 = call double @llvm.fmuladd.f64(double %17, double %25, double %44)
  ret double %45
}

; Function Attrs: mustprogress noinline norecurse uwtable
define dso_local noundef i32 @main(i32 noundef %0, i8** noundef %1) #7 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store double 1.000000e+02, double* %6, align 8
  store double 1.000000e+02, double* %7, align 8
  store double 5.000000e-02, double* %8, align 8
  store double 2.000000e-01, double* %9, align 8
  store double 1.000000e+00, double* %10, align 8
  %13 = call noundef double @_Z10call_priceRKdS0_S0_S0_S0_(double* noundef nonnull align 8 dereferenceable(8) %6, double* noundef nonnull align 8 dereferenceable(8) %7, double* noundef nonnull align 8 dereferenceable(8) %8, double* noundef nonnull align 8 dereferenceable(8) %9, double* noundef nonnull align 8 dereferenceable(8) %10)
  store double %13, double* %11, align 8
  %14 = call noundef double @_Z9put_priceRKdS0_S0_S0_S0_(double* noundef nonnull align 8 dereferenceable(8) %6, double* noundef nonnull align 8 dereferenceable(8) %7, double* noundef nonnull align 8 dereferenceable(8) %8, double* noundef nonnull align 8 dereferenceable(8) %9, double* noundef nonnull align 8 dereferenceable(8) %10)
  store double %14, double* %12, align 8
  %15 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i64 0, i64 0))
  %16 = load double, double* %6, align 8
  %17 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %15, double noundef %16)
  %18 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %17, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %19 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.1, i64 0, i64 0))
  %20 = load double, double* %7, align 8
  %21 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %19, double noundef %20)
  %22 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %21, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %23 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.2, i64 0, i64 0))
  %24 = load double, double* %8, align 8
  %25 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %23, double noundef %24)
  %26 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %25, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %27 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.3, i64 0, i64 0))
  %28 = load double, double* %9, align 8
  %29 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %27, double noundef %28)
  %30 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %29, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %31 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.4, i64 0, i64 0))
  %32 = load double, double* %10, align 8
  %33 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %31, double noundef %32)
  %34 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %33, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %35 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5, i64 0, i64 0))
  %36 = load double, double* %11, align 8
  %37 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %35, double noundef %36)
  %38 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %37, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %39 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.6, i64 0, i64 0))
  %40 = load double, double* %12, align 8
  %41 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %39, double noundef %40)
  %42 = call noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8) %41, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  ret i32 0
}

declare noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8), i8* noundef) #1

declare noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEd(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8), double noundef) #1

declare noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8), %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* noundef) #1

declare noundef nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(%"class.std::basic_ostream"* noundef nonnull align 8 dereferenceable(8)) #1

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
attributes #6 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #7 = { mustprogress noinline norecurse uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 14.0.6"}

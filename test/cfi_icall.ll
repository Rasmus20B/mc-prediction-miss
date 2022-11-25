; ModuleID = '../test/cfi_icall.c'
source_filename = "../test/cfi_icall.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.foo = type { [1 x i32 (i32)*], [1 x i32 (i32)*], [1 x i32 (float)*], [1 x i32 (i32)*] }

@.str = private unnamed_addr constant [20 x i8] c"Usage: %s <option>\0A\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"Option values:\0A\00", align 1
@.str.2 = private unnamed_addr constant [26 x i8] c"\090\09Call correct function\0A\00", align 1
@.str.3 = private unnamed_addr constant [56 x i8] c"\091\09Call the wrong function but with the same signature\0A\00", align 1
@.str.4 = private unnamed_addr constant [57 x i8] c"\092\09Call a float function with an int function signature\0A\00", align 1
@.str.5 = private unnamed_addr constant [39 x i8] c"\093\09Call into the middle of a function\0A\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.7 = private unnamed_addr constant [66 x i8] c"\09All other options are undefined, but should be caught by CFI :)\0A\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c"\0A\0A\00", align 1
@.str.9 = private unnamed_addr constant [82 x i8] c"Here are some pointers so clang doesn't optimize away members of `struct foo f`:\0A\00", align 1
@.str.10 = private unnamed_addr constant [16 x i8] c"\09int_funcs: %p\0A\00", align 1
@f = internal global %struct.foo { [1 x i32 (i32)*] [i32 (i32)* @int_arg], [1 x i32 (i32)*] [i32 (i32)* @bad_int_arg], [1 x i32 (float)*] [i32 (float)* @float_arg], [1 x i32 (i32)*] [i32 (i32)* bitcast (i8* getelementptr (i8, i8* bitcast (i32 (i32)* @not_entry_point to i8*), i64 32) to i32 (i32)*)] }, align 8
@.str.11 = private unnamed_addr constant [20 x i8] c"\09bad_int_funcs: %p\0A\00", align 1
@.str.12 = private unnamed_addr constant [18 x i8] c"\09float_funcs: %p\0A\00", align 1
@.str.13 = private unnamed_addr constant [18 x i8] c"\09not_entries: %p\0A\00", align 1
@.str.14 = private unnamed_addr constant [21 x i8] c"Calling a function:\0A\00", align 1
@.str.15 = private unnamed_addr constant [13 x i8] c"In %s: (%d)\0A\00", align 1
@__FUNCTION__.int_arg = private unnamed_addr constant [8 x i8] c"int_arg\00", align 1
@.str.16 = private unnamed_addr constant [39 x i8] c"CFI will not protect transfer to here\0A\00", align 1
@__FUNCTION__.bad_int_arg = private unnamed_addr constant [12 x i8] c"bad_int_arg\00", align 1
@.str.17 = private unnamed_addr constant [37 x i8] c"CFI should protect transfer to here\0A\00", align 1
@.str.18 = private unnamed_addr constant [13 x i8] c"In %s: (%f)\0A\00", align 1
@__FUNCTION__.float_arg = private unnamed_addr constant [10 x i8] c"float_arg\00", align 1
@.str.19 = private unnamed_addr constant [75 x i8] c"CFI ensures control flow only transfers to potentially valid destinations\0A\00", align 1
@__FUNCTION__.not_entry_point = private unnamed_addr constant [16 x i8] c"not_entry_point\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %7 = load i32, i32* %4, align 4
  %8 = icmp ne i32 %7, 2
  br i1 %8, label %9, label %27

9:                                                ; preds = %2
  %10 = load i8**, i8*** %5, align 8
  %11 = getelementptr inbounds i8*, i8** %10, i64 0
  %12 = load i8*, i8** %11, align 8
  %13 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* noundef %12)
  %14 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.1, i64 0, i64 0))
  %15 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.2, i64 0, i64 0))
  %16 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.3, i64 0, i64 0))
  %17 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.4, i64 0, i64 0))
  %18 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([39 x i8], [39 x i8]* @.str.5, i64 0, i64 0))
  %19 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i64 0, i64 0))
  %20 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.7, i64 0, i64 0))
  %21 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.8, i64 0, i64 0))
  %22 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([82 x i8], [82 x i8]* @.str.9, i64 0, i64 0))
  %23 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.10, i64 0, i64 0), i8* noundef bitcast (%struct.foo* @f to i8*))
  %24 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.11, i64 0, i64 0), i8* noundef bitcast (i32 (i32)** getelementptr inbounds (%struct.foo, %struct.foo* @f, i32 0, i32 1, i64 0) to i8*))
  %25 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.12, i64 0, i64 0), i8* noundef bitcast (i32 (float)** getelementptr inbounds (%struct.foo, %struct.foo* @f, i32 0, i32 2, i64 0) to i8*))
  %26 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.13, i64 0, i64 0), i8* noundef bitcast (i32 (i32)** getelementptr inbounds (%struct.foo, %struct.foo* @f, i32 0, i32 3, i64 0) to i8*))
  store i32 1, i32* %3, align 4
  br label %42

27:                                               ; preds = %2
  %28 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.14, i64 0, i64 0))
  %29 = load i8**, i8*** %5, align 8
  %30 = getelementptr inbounds i8*, i8** %29, i64 1
  %31 = load i8*, i8** %30, align 8
  %32 = getelementptr inbounds i8, i8* %31, i64 0
  %33 = load i8, i8* %32, align 1
  %34 = sext i8 %33 to i32
  %35 = sub nsw i32 %34, 48
  store i32 %35, i32* %6, align 4
  %36 = load i32, i32* %6, align 4
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds [1 x i32 (i32)*], [1 x i32 (i32)*]* getelementptr inbounds (%struct.foo, %struct.foo* @f, i32 0, i32 0), i64 0, i64 %37
  %39 = load i32 (i32)*, i32 (i32)** %38, align 8
  %40 = load i32, i32* %6, align 4
  %41 = call i32 %39(i32 noundef %40)
  store i32 %41, i32* %3, align 4
  br label %42

42:                                               ; preds = %27, %9
  %43 = load i32, i32* %3, align 4
  ret i32 %43
}

declare i32 @printf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind uwtable
define internal i32 @int_arg(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.15, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @__FUNCTION__.int_arg, i64 0, i64 0), i32 noundef %3)
  ret i32 0
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bad_int_arg(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([39 x i8], [39 x i8]* @.str.16, i64 0, i64 0))
  %4 = load i32, i32* %2, align 4
  %5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.15, i64 0, i64 0), i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__FUNCTION__.bad_int_arg, i64 0, i64 0), i32 noundef %4)
  ret i32 0
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @float_arg(float noundef %0) #0 {
  %2 = alloca float, align 4
  store float %0, float* %2, align 4
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.17, i64 0, i64 0))
  %4 = load float, float* %2, align 4
  %5 = fpext float %4 to double
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__FUNCTION__.float_arg, i64 0, i64 0), double noundef %5)
  ret i32 0
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @not_entry_point(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void asm sideeffect "nop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0Anop\0A", "~{dirflag},~{fpsr},~{flags}"() #3, !srcloc !6
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.19, i64 0, i64 0))
  %4 = load i32, i32* %2, align 4
  %5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.15, i64 0, i64 0), i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__FUNCTION__.not_entry_point, i64 0, i64 0), i32 noundef %4)
  %6 = load i32, i32* %2, align 4
  call void @exit(i32 noundef %6) #4
  unreachable
}

; Function Attrs: noreturn nounwind
declare void @exit(i32 noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 14.0.6"}
!6 = !{i64 821, i64 830, i64 838, i64 846, i64 854, i64 862, i64 870, i64 878, i64 886, i64 894, i64 914, i64 922, i64 930, i64 938, i64 946, i64 954, i64 962, i64 970, i64 978, i64 986, i64 1006, i64 1014, i64 1022, i64 1030, i64 1038, i64 1046, i64 1054, i64 1062, i64 1070, i64 1078, i64 1098, i64 1106, i64 1114, i64 1122, i64 1130, i64 1138, i64 1146, i64 1154, i64 1162, i64 1170, i64 1190, i64 1198, i64 1206, i64 1214, i64 1222, i64 1230, i64 1238, i64 1246, i64 1254, i64 1262, i64 1282, i64 1290, i64 1298, i64 1306, i64 1314, i64 1322, i64 1330, i64 1338, i64 1346, i64 1354, i64 1374, i64 1382, i64 1390, i64 1398, i64 1406, i64 1414, i64 1422, i64 1430, i64 1438, i64 1446, i64 1466, i64 1474, i64 1482, i64 1490, i64 1498, i64 1506, i64 1514, i64 1522, i64 1530, i64 1538}

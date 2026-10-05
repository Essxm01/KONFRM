import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class StatesScenario extends StatelessWidget {
  const StatesScenario({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'عينات توضيحية غير مرتبطة بحالة خادم',
        style: KonfrmTypography.label,
      ),
      SizedBox(height: 8),
      StatusBadge(label: 'قيد المراجعة'),
      SizedBox(height: 8),
      StatusBadge(label: 'حالة العقار — مثال مختبر'),
      SizedBox(height: 8),
      StatusBadge(label: 'مراجعة العقار — مثال مختبر'),
      SizedBox(height: 8),
      StatusBadge(label: 'دفعة — مثال مختبر'),
      SizedBox(height: 8),
      StatusBadge(label: 'رصيد — مثال مختبر'),
      SizedBox(height: 8),
      StatusBadge(label: 'طلب سحب — مثال مختبر'),
      SizedBox(height: 8),
      StatusBadge(label: 'هوية المالك — مثال مختبر'),
      SizedBox(height: 8),
      StatusBadge(label: 'مستند تحقق — مثال مختبر'),
      SizedBox(height: 12),
      StateView(
        kind: StateKind.loading,
        heading: 'جارٍ التحميل',
        explanation: 'هذه معاينة حالة تحميل فقط.',
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.error,
        heading: 'تعذر تحميل المحتوى',
        explanation: 'لم نتمكن من جلب البيانات.',
        recoveryLabel: 'إعادة المحاولة',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.empty,
        heading: 'لا توجد عناصر',
        explanation: 'حالة فراغ مستقلة بعد نجاح القراءة.',
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.offline,
        heading: 'الاتصال غير متاح',
        explanation:
            'تعذر تحديث هذه المعاينة. تحقق من الاتصال ثم أعد المحاولة.',
        recoveryLabel: 'إعادة المحاولة',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.unauthorized,
        heading: 'يلزم وصول مخول',
        explanation: 'معاينة حالة وصول تتطلب التحقق من صلاحية المستخدم.',
        recoveryLabel: 'متابعة تسجيل الدخول',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.partial,
        heading: 'بعض المحتوى غير متاح',
        explanation: 'هذه معاينة لعرض جزء متاح مع توضيح الجزء غير المتاح.',
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.stale,
        heading: 'المعلومات قديمة',
        explanation: 'لم يكتمل تحديث المعاينة؛ لا تعرضها كبيانات حالية.',
        recoveryLabel: 'تحديث',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.conflict,
        heading: 'توجد معلومات متعارضة',
        explanation: 'تتطلب هذه المعاينة مراجعة قبل متابعة التغيير.',
      ),
      SizedBox(height: 16),
      SectionAlert(
        message: 'تعذر الاتصال. تحقق من الشبكة ثم أعد المحاولة.',
        recoveryLabel: 'إعادة المحاولة',
        onRecovery: _noop,
        isError: true,
      ),
    ],
  );
}

void _noop() {}

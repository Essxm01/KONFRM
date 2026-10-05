import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class InputsScenario extends StatelessWidget {
  const InputsScenario({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const InputField(label: 'الاسم', helper: 'اكتب الاسم كما يظهر لك'),
      const SizedBox(height: 16),
      PhoneField(label: 'رقم الهاتف'),
      const SizedBox(height: 16),
      const InputField(
        label: 'بريد إلكتروني',
        keyboardType: TextInputType.emailAddress,
        textDirection: TextDirection.ltr,
        error: 'مثال رسالة خطأ مرتبطة بالحقل',
      ),
      const SizedBox(height: 16),
      SearchField(
        label: 'البحث',
        placeholder: 'ابحث عن إقامة',
        controller: controller,
      ),
    ],
  );
}

class BidiScenario extends StatelessWidget {
  const BidiScenario({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _ArabicFirstValue(
        prefix: 'اتصل على',
        value: '+20 100 123 4567',
        suffix: 'للتواصل.',
      ),
      SizedBox(height: 12),
      _ArabicFirstValue(
        prefix: 'البريد التجريبي',
        value: 'user@example.test',
        suffix: 'للمعاينة.',
      ),
      SizedBox(height: 12),
      _ArabicFirstValue(
        prefix: 'معرّف الحجز',
        value: 'BK-183223',
        suffix: 'ومعرّف العقار',
      ),
      _ArabicFirstValue(
        prefix: 'العقار',
        value: 'PR-0091',
        suffix: 'أمثلة مختبرية.',
      ),
      SizedBox(height: 12),
      _ArabicFirstValue(
        prefix: 'القيمة المعروضة',
        value: _labMoney(1600),
        suffix: 'مثال تنسيق فقط.',
      ),
      SizedBox(height: 12),
      _ArabicFirstValue(
        prefix: 'النظام',
        value: 'KONFRM system',
        suffix: 'واجهة عربية أولاً.',
      ),
    ],
  );
}

class _ArabicFirstValue extends StatelessWidget {
  const _ArabicFirstValue({
    required this.prefix,
    required this.value,
    required this.suffix,
  });
  final String prefix;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    runSpacing: 2,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(prefix, style: KonfrmTypography.body),
      isolateLtr(Text(value, style: KonfrmTypography.body)),
      Text(suffix, style: KonfrmTypography.body),
    ],
  );
}

String _labMoney(int amount) =>
    '${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')} ج.م';

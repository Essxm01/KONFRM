import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful account tab for KONFRM | GUEST.
///
/// Reflects an unauthenticated guest session honestly. Does not render
/// fake authenticated personas, mock loyalty balances, or fabricated
/// identity documents.
class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('account-scroll-view'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('الحساب', style: KonfrmTypography.pageTitle),
          const SizedBox(height: 6),
          Text('إدارة الجلسة والإعدادات والدعم', style: KonfrmTypography.body),
          const SizedBox(height: 24),
          StructuralContainer(
            key: const Key('account-guest-profile-card'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 44,
                      color: Color(0xFF111827),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'جلسة زائر (غير مسجل)',
                            style: KonfrmTypography.sectionTitle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'استكشف العقارات والأسعار بحرية',
                            style: KonfrmTypography.supporting,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  key: const Key('account-login-button'),
                  label: 'تسجيل الدخول / إنشاء حساب',
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StructuralContainer(
            key: const Key('account-settings-card'),
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.language,
                  title: 'اللغة',
                  trailing: 'العربية (افتراضي)',
                ),
                const Divider(
                  height: 24,
                  thickness: 1,
                  color: Color(0xFFE5E7EB),
                ),
                _SettingsRow(
                  icon: Icons.help_outline,
                  title: 'المساعدة والدعم',
                  trailing: 'مركز المساعدة',
                ),
                const Divider(
                  height: 24,
                  thickness: 1,
                  color: Color(0xFFE5E7EB),
                ),
                _SettingsRow(
                  icon: Icons.info_outline,
                  title: 'عن المنصة',
                  trailing: 'KONFRM v0.1.0',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final isLargeFont = MediaQuery.textScalerOf(context).scale(14) > 18;
    if (isLargeFont) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: const Color(0xFF475467)),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: KonfrmTypography.bodyStrong)),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 34),
            child: Text(trailing, style: KonfrmTypography.supporting),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF475467)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: KonfrmTypography.bodyStrong)),
        const SizedBox(width: 8),
        Text(trailing, style: KonfrmTypography.supporting),
      ],
    );
  }
}

// File: lib/core/constants/enums/app_enums.dart
// Purpose: Defines all enums used throughout the app for type safety

enum TransactionType {
  income,
  expense,
  transfer,
  investment,
}

enum AccountType {
  savings,
  checking,
  investment,
  loan,
  credit,
  cash,
}

enum CreditCardType {
  visa,
  mastercard,
  amex,
  discover,
  rupay,
}

enum Currency {
  inr,
  usd,
  eur,
  gbp,
  jpy,
  cad,
  aud,
  chf,
  cny,
}

enum AppThemeMode {
  light,
  dark,
  system,
}

enum NotificationType {
  paymentReminder,
  creditUtilizationAlert,
  lowBalanceAlert,
  billReminder,
  goalAchievement,
}

enum ChartType {
  line,
  bar,
  pie,
  donut,
  area,
}

enum TimePeriod {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}

enum SortOrder {
  ascending,
  descending,
}

enum SortField {
  date,
  amount,
  description,
  category,
  account,
}

enum FilterType {
  all,
  income,
  expense,
  transfer,
  category,
  account,
  dateRange,
  amountRange,
}

enum SmsBankType {
  sbi,
  hdfc,
  icici,
  axis,
  kotak,
  pnb,
  canara,
  union,
  other,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

enum RecurringType {
  none,
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
}

enum GoalType {
  savings,
  debt,
  investment,
  emergency,
  vacation,
  other,
}

enum GoalStatus {
  active,
  completed,
  paused,
  cancelled,
}

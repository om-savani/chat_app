import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  Widget get ph => SizedBox(height: toDouble());
  Widget get pw => SizedBox(width: toDouble());
}

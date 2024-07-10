import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:javascript_channel_example/payment-provider/kushki.dart';

final kushkiService = Provider((ref) => KushkiService(550));

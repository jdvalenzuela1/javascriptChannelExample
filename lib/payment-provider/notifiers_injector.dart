import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:javascript_channel_example/payment-provider/kushki.dart';
import 'package:javascript_channel_example/payment-provider/mercado-pago.dart';

final kushkiService = Provider((ref) => KushkiService(550));
final mercadopagoService = Provider((ref) => MercadoPagoService(550));

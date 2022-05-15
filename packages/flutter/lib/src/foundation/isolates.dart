// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import '_isolates_io.dart'
  if (dart.library.html) '_isolates_web.dart' as isolates;

/// Signature for the callback passed to [compute].
///
/// {@macro flutter.foundation.compute.types}
///
/// Instances of [ComputeCallback] must be functions that can be sent to an
/// isolate.
/// {@macro flutter.foundation.compute.callback}
///
/// {@macro flutter.foundation.compute.types}
typedef ComputeCallback<Q, R> = FutureOr<R> Function(Q message);

/// The signature of [compute], which spawns an isolate, runs `callback` on
/// that isolate, passes it `message`, and (eventually) returns the value
/// returned by `callback`.
///
/// {@macro flutter.foundation.compute.usecase}
///
/// The function used as `callback` must be one that can be sent to an isolate.
/// {@macro flutter.foundation.compute.callback}
///
/// {@macro flutter.foundation.compute.types}
///
/// The `debugLabel` argument can be specified to provide a name to add to the
/// [Timeline]. This is useful when profiling an application.
typedef ComputeImpl = Future<R> Function<Q, R>(ComputeCallback<Q, R> callback, Q message, { String? debugLabel });

/// A function that spawns an isolate and runs the provided `callback` on that
/// isolate, passes it the provided `message`, and (eventually) returns the
/// value returned by `callback`.
///
/// {@template flutter.foundation.compute.usecase}
/// This is useful for operations that take longer than a few milliseconds, and
/// which would therefore risk skipping frames. For tasks that will only take a
/// few milliseconds, consider [SchedulerBinding.scheduleTask] instead.
/// {@endtemplate}
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=5AxWC49ZMzs}
///
/// {@tool snippet}
/// The following code uses the [compute] function to check whether a given
/// integer is a prime number.
///
/// ```dart
/// Future<bool> isPrime(int value) {
///   return compute(_calculate, value);
/// }
///
/// bool _calculate(int value) {
///   if (value == 1) {
///     return false;
///   }
///   for (int i = 2; i < value; ++i) {
///     if (value % i == 0) {
///       return false;
///     }
///   }
///   return true;
/// }
/// ```
/// {@end-tool}
///
/// The function used as `callback` must be one that can be sent to an isolate.
/// {@template flutter.foundation.compute.callback}
/// Qualifying functions include:
///
///   * top-level functions
///   * static methods
///   * closures that only capture objects that can be sent to an isolate
///
/// Using closures must be done with care. Due to
/// [dart-lang/sdk#36983](https://github.com/dart-lang/sdk/issues/36983) a
/// closure may captures objects that, while not directly used in the closure
/// itself, may prevent it from being sent to an isolate.
/// {@endtemplate}
///
/// {@template flutter.foundation.compute.types}
/// The [compute] method accepts the following parameters:
///
///  * `Q` is the type of the message that kicks off the computation.
///  * `R` is the type of the value returned.
///
/// There are limitations on the values that can be sent and received to and
/// from isolates. These limitations constrain the values of `Q` and `R` that
/// are possible. See the discussion at [SendPort.send].
///
/// The same limitations apply to any errors generated by the computation.
/// {@endtemplate}
///
/// See also:
///
///   * [ComputeImpl], for the [compute] function's signature.
const ComputeImpl compute = isolates.compute;

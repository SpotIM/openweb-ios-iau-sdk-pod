// Intentionally empty.
//
// SwiftPM binary targets (the OpenWebIAUSDK and KmmSpotimStandaloneAd
// xcframeworks) cannot declare their own dependencies. This wrapper target is
// the real product target — it carries the SDK's remote package dependencies
// and re-exports the binary frameworks. It needs at least one source file to
// compile, which this file provides.

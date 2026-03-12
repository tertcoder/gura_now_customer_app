/// Configuration for mock data mode.
/// 
/// Set `useMockData` to true to use mock data sources instead of real API calls.
/// This is useful for:
/// - UI development without backend
/// - Testing UI flows
/// - Demos and presentations
library;

/// Global flag to enable/disable mock data mode.
/// 
/// When true, all data sources will use mock implementations.
/// When false, all data sources will use real API implementations.
const bool useMockData = true;

/// Print debug messages when mock data is being used.
const bool debugMockMode = true;

/// Log mock data operations.
void logMockOperation(String operation) {
  if (debugMockMode) {
    print('🎭 [MOCK MODE] $operation');
  }
}

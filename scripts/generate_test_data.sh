testDataPath='Tests/TestData'

# Build frameworks
(cd $testDataPath && carthage bootstrap --platform ios --cache-builds)

# Remove unwanted directories
find $testDataPath/Carthage/* -type d ! -name 'Build' ! -name 'iOS' ! -name '*.framework' -exec rm -Rf {} +

# Remove unwanted files
find $testDataPath/Carthage/* ! -type d ! -name '*.plist' -exec rm -f {} +
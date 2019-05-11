# Clean
rm -Rf $fixturesDataPath
mkdir -p $fixturesDataPath

# Copy the cartfile to the recently created fixture data
cp $mainCartfilePath $fixturesDataPath/cartfile

# Build frameworks
(cd $fixturesDataPath && carthage bootstrap --platform ios --cache-builds)
# Remove unwanted directories
find $fixturesDataPath/Carthage/* -type d ! -name 'Build' ! -name 'iOS' ! -name '*.framework' -exec rm -Rf {} +
# Remove unwanted files
find $fixturesDataPath/Carthage/* ! -type d ! -name '*.plist' -exec rm -f {} +
testDataPath='Tests/TestData'
fixturePath='Tests/Fixture'

# Clean
rm -Rf $fixturePath

# Copy test data to fixture location
cp -R $testDataPath $fixturePath

# Generate fixture
packagePath=$(pwd)
(cd $testDataPath && swift run --package-path $packagePath CocoaPodsEndgame snap)

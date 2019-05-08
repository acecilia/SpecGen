set -eou pipefail

testDataPath='Tests/Fixtures/TestData'
fixtureWithCarthagePath='Tests/Fixtures/WithCarthage'
fixtureWithoutCarthagePath='Tests/Fixtures/WithoutCarthage'

# Clean
rm -Rf $fixtureWithCarthagePath
rm -Rf $fixtureWithoutCarthagePath

# Copy test data to fixture location
cp -R $testDataPath $fixtureWithCarthagePath
cp -R $testDataPath $fixtureWithoutCarthagePath

# Generate fixture
packagePath=$(pwd)
(cd $fixtureWithCarthagePath && swift run --package-path $packagePath CocoaPodsEndgame snap)
(cd $fixtureWithoutCarthagePath && swift run --package-path $packagePath CocoaPodsEndgame snap --disableCarthage)
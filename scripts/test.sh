set -eou pipefail

generatedTestPath='build/Tests'
testWithCarthagePath="$generatedTestPath/WithCarthage"
testWithoutCarthagePath="$generatedTestPath/WithoutCarthage"

fixturesPath='Tests/Fixtures'
testDataPath="$fixturesPath/TestData"
fixtureWithCarthagePath="$fixturesPath/WithCarthage"
fixtureWithoutCarthagePath="$fixturesPath/WithoutCarthage"

# Clean
mkdir -p $generatedTestPath
rm -Rf $testWithCarthagePath
rm -Rf $testWithoutCarthagePath

# Copy test data to fixture location
cp -R $testDataPath $testWithCarthagePath
cp -R $testDataPath $testWithoutCarthagePath

# Generate fixture
packagePath=$(pwd)
(cd $testWithCarthagePath && swift run --package-path $packagePath CocoaPodsEndgame snap)
(cd $testWithoutCarthagePath && swift run --package-path $packagePath CocoaPodsEndgame snap --disableCarthage)

# Compare test output with fixture
exitCode=0
diff -qr $testWithCarthagePath $fixtureWithCarthagePath --exclude='.DS_Store' || exitCode=$?
if [ $exitCode -eq 1 ];then
   echo "The fixture with carthage did not match the test output"
   exit 1
fi

diff -qr $testWithoutCarthagePath $fixtureWithoutCarthagePath --exclude='.DS_Store' || exitCode=$?
if [ $exitCode -eq 1 ];then
   echo "The fixture without carthage did not match the test output"
   exit 1
fi

echo "All checks passed successfully"
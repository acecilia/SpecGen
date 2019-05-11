for fixtureName in $fixtureNames; do
  echo "Running test for fixture '$fixtureName'"

  testPath=$testsPath/$fixtureName
  fixturePath=$fixturesPath/$fixtureName

  # Compare fixture data with fixture
  exitCode=0
  diff -qr $fixturesDataPath $fixturePath --exclude='Cartfile' --exclude='*.podspec' --exclude='Podfile' || exitCode=$?
  if [ $exitCode -eq 1 ];then
    echo "The fixture data in '$fixturesDataPath' did not match the fixture at path '$fixturePath'"
    exit 1
  fi

  # Compare test with fixture
  exitCode=0
  diff -qr $testPath $fixturePath || exitCode=$?
  if [ $exitCode -eq 1 ];then
    echo "The test '$fixtureName' at path '$testPath' did not match the fixture at path '$fixturePath'"
    exit 1
  fi
done

echo "All checks passed successfully"

outputPath=$1

# Clean
rm -Rf $outputPath
mkdir -p $outputPath

for fixtureName in $fixtureNames; do
  echo "Generating fixture '$fixtureName'"

  fixturePath=$outputPath/$fixtureName
  cartfilePath=$cartfilesPath/$fixtureName

  # Copy test data to fixture location
  cp -R $fixturesDataPath $fixturePath
  # Copy the cartfile to the fixture location
  cp -f $cartfilePath $fixturePath/Cartfile

  # Run specgen with different arguments depending on the test
  if [ "$fixtureName" == "$WithoutCarthage" ]; then
    (cd $fixturePath && swift run --package-path $packagePath specgen bootstrap --disableCarthage)
  else
    (cd $fixturePath && swift run --package-path $packagePath specgen bootstrap)
  fi
done
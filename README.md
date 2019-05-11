# SpecGen
SpecGen is a command line tool written in Swift that generates `.podspec` files from frameworks, with the goal of consumming them in a [CocoaPods](https://github.com/CocoaPods/CocoaPods) setup.

* 👌 Generates `.podspec` files from `.framework` files
* 👌[Carthage](https://github.com/Carthage/Carthage) compatibility, so the generated `.podspec` files contain the version specified in the `Carfile.resolved` (effectively delegating to Carthage the dependency resolution)
* 😂 Massively reduce build times by substituting source code pods with their `.framework`
* 👌 Improve Xcode speed and responsiveness by substituting source code pods with their `.framework`
* 💥 Use CocoaPods and Carthage together, allowing pods to depend on frameworks installed by Carthage

## Installing
### [Mint](https://github.com/yonaskolb/mint)
```sh
mint install acecilia/specgen
```

### Make

```sh
git clone https://github.com/acecilia/specgen.git
cd SpecGen
make
```

## Usage
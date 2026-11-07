#!/bin/bash
set -e
SDK=$(xcrun --sdk iphoneos --show-sdk-path)

clang -c -fobjc-arc -target arm64-apple-ios12.0 -isysroot "$SDK" \
      -I. HVSonMenu.m  -o HVSonMenu.o

clang -c -fobjc-arc -target arm64-apple-ios12.0 -isysroot "$SDK" \
      -I. HVSonTweak.m -o HVSonTweak.o

clang -dynamiclib -fobjc-arc -target arm64-apple-ios12.0 -isysroot "$SDK" \
      -framework UIKit -framework Foundation \
      HVSonMenu.o HVSonTweak.o -o HVSonTool.dylib

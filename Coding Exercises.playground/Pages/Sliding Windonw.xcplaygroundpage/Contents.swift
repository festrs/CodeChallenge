//: [Previous](@previous)

import Foundation

/*
 Minimum Length Substrings

 You are given two strings s and t. You can select any substring of string s and rearrange the characters of the selected substring. Determine the minimum length of the substring of s such that string t is a substring of the selected substring.

 Signature

 int minLengthSubstring(String s, String t)

 Input

 s and t are non-empty strings that contain less than 1,000,000 characters each

 Output

 Return the minimum length of the substring of s. If it is not possible, return -1

 Example
 s = "adobecodebanc"
      0123456789012
                 i
         j

 [(a, 0),
 (b, 0),
 (c, 0)]

 count = 1
 minLenght = 5
 found = true
 left = 1 // inicio da menor substring
 right = 6 // fim da menor substring

 t = "abc"


 output = 5

 Explanation:
 Substring "dcbef" can be rearranged to "cfdeb", "cefdb", and so on. String t is a substring of "cfdeb". Thus, the minimum length required is 5.
 */

extension String {
    func minLengthOfRearrangedSubstring(containing substring: String) -> Int {
            // Write your code here
        var left = startIndex
        var right = endIndex
        var found = false
        var minLenght = self.count
        var mapCount = Dictionary(substring.map { ($0, 1) }, uniquingKeysWith: +)
        var count = mapCount.count

        var i = startIndex
        var j = startIndex

        while j < endIndex {
            let characterJ = self[j]
            j = index(after: j)
            if var characterCount = mapCount[characterJ] {
                characterCount -= 1
                mapCount[characterJ] = characterCount
                if characterCount == 0 {
                    count -= 1
                }
            }

            if count > 0 { continue }

            while count == 0 {
                let characterI = self[i]
                i = self.index(after: i)

                if var characterCount = mapCount[characterI] {
                    characterCount += 1
                    mapCount[characterI] = characterCount
                    if characterCount > 0 {
                        count += 1
                    }
                }
            }

            let distanceIJ = distance(from: i, to: j)
            if distanceIJ < minLenght {
                minLenght = distanceIJ + 1
                left = i
                right = j
                found = true
            }
        }

        if found {
            return minLenght
        } else {
            return -1
        }
    }
}

// These are the tests we use to determine if the solution is correct.
// You can add your own at the bottom.

var testCaseNumber = 1

private func check(_ expectedValue: Int, matches output: Int) {
    let rightTick = "\u{2713}"
    let wrongTick = "\u{2717}"

    let result = expectedValue == output
    if result {
        print("\(rightTick) Test #\(testCaseNumber)")
    } else {
        print("\(wrongTick) Test #\(testCaseNumber) Expected: \(expectedValue) Your output: \(output)")
    }
    testCaseNumber += 1
}

let s1 = "dcbefebce"
let t1 = "fd"
let output1 = s1.minLengthOfRearrangedSubstring(containing: t1)
check(5, matches: output1)

let s2 = "bfbeadbcbcbfeaaeefcddcccbbbfaaafdbebedddf"
let t2 = "cbccfafebccdccebdd"
let output2 = s2.minLengthOfRearrangedSubstring(containing: t2)
check(-1, matches: output2)

let s3 = "adobecodebanc"
let t3 = "abc"
let output3 = s3.minLengthOfRearrangedSubstring(containing: t3)
check(4, matches: output3)

let s4 = "dcbefebcegdf"
let t4 = "fdgf"
let output4 = s4.minLengthOfRearrangedSubstring(containing: t4)
check(8, matches: output4)

//: [Next](@next)

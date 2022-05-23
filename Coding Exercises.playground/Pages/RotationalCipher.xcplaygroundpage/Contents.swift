//: [Previous](@previous)

import UIKit

/*
 Rotational Cipher

 One simple way to encrypt a string is to "rotate" every alphanumeric character by a certain amount. Rotating a character means replacing it with another character that is a certain number of steps away in normal alphabetic or numerical order.

 For example, if the string "Zebra-493?" is rotated 3 places, the resulting string is "Cheud-726?". Every alphabetic character is replaced with the character 3 letters higher (wrapping around from Z to A), and every numeric character replaced with the character 3 digits higher (wrapping around from 9 to 0). Note that the non-alphanumeric characters remain unchanged.

 Given a string and a rotation factor, return an encrypted string.

 Signature

 string rotationalCipher(string input, int rotationFactor)

 Input

 1 <= |input| <= 1,000,000
 0 <= rotationFactor <= 1,000,000

 Output

 Return the result of rotating input a number of times equal to rotationFactor.

 Example 1

 input = Zebra-493?
 rotationFactor = 3
 output = Cheud-726?

 Example 2

 input = abcdefghijklmNOPQRSTUVWXYZ0123456789
 rotationFactor = 39
 output = nopqrstuvwxyzABCDEFGHIJKLM9012345678

 */

struct RotationalCipher {
    let backing: String

    func cipher(withRotationFactor: Int) -> String {
        var result: String = ""

        let alphabet: ClosedRange<Unicode.Scalar> = "a"..."z"
        let alphabetUpper: ClosedRange<Unicode.Scalar> = "A"..."Z"
        let scalars = (alphabet.lowerBound.value...alphabet.upperBound.value).compactMap(Unicode.Scalar.init)
        let scalarsUpper = (alphabetUpper.lowerBound.value...alphabetUpper.upperBound.value).compactMap(Unicode.Scalar.init)
        let numbers: ClosedRange<Unicode.Scalar> = "0"..."9"
        let scalarsNumbers = (numbers.lowerBound.value...numbers.upperBound.value).compactMap(Unicode.Scalar.init)
        let characterss = CharacterSet.lowercaseLetters
        print(characterss)

        for unicode in backing.unicodeScalars {
            if let index = scalarsUpper.firstIndex(of: unicode) {
                let value = Int(index)
                let distance = scalars.count
                let resultpos = (value + (withRotationFactor % distance) + distance) % distance
                result.append(contentsOf: String(scalarsUpper[resultpos]))
            } else if let index = scalars.firstIndex(of: unicode) {
                let value = Int(index)
                let distance = scalars.count
                let resultpos = (value + (withRotationFactor % distance) + distance) % distance
                result.append(contentsOf: String(scalars[resultpos]))
            } else if let index = scalarsNumbers.firstIndex(of: unicode) {
                let value = Int(index)
                let distance = scalarsNumbers.count
                let resultpos = (value + (withRotationFactor % distance) + distance) % distance
                result.append(contentsOf: String(scalarsNumbers[resultpos]))
            } else {
                result.append(contentsOf: String(unicode))
            }
        }
        return result
    }
}

// These are the tests we use to determine if the solution is correct.
// You can add your own at the bottom.

private extension String {
    var characterArray: String {
        return "[\"\(self)\"]"
    }
}

private var testCaseNumber = 1;

private extension RotationalCipher {
    static func check(_ expectedValue: String, against output: String) {
        let rightTick = "\u{2713}";
        let wrongTick = "\u{2717}";

        let result = expectedValue == output
        if result {
            print("\(rightTick) Test #\(testCaseNumber)")
        } else {
            print("\(wrongTick) Test #\(testCaseNumber) Expected: \(expectedValue.characterArray) Your output: \(output.characterArray)")
        }
        testCaseNumber += 1
    }
}

let input1 = "All-convoYs-9-be:Alert1."
let expected1 = "Epp-gsrzsCw-3-fi:Epivx5."
let output1 = RotationalCipher(backing: input1).cipher(withRotationFactor: 4)
RotationalCipher.check(expected1, against: output1)

let input2 = "abcdZXYzxy-999.@"
let expected2 = "stuvRPQrpq-999.@"
let output2 = RotationalCipher(backing: input2).cipher(withRotationFactor: 200)
RotationalCipher.check(expected2, against: output2)

/*
 Complexity 1

 We need to process every character, even if only to check whether or not it's alphanumeric, so no solution can be faster than O(n) where, n is the number of characters in the input string. Within each character processing, however, consider how you might transform it optimally.

 Complexity 2

 Since every character can be handled independently, we just need an O(1) operation for transforming a character into its ciphered version. In particular, we don’t want to use O(rotationFactor) steps for each character.
 If your solution involves iterating through rotations one at a time (e.g. if a rotationFactor of 6 causes your code to consider transforming A to B to C to D to E to F to G without skipping directly from A to G), then you should consider how you might cut out those steps in between. If reducing the time complexity means you now use a meaningful amount of additional space, then you should consider how you might avoid using that space.

 Edge cases 1

 Does your code correctly handle all non-alphanumeric characters? The list of non-alphanumeric characters is harder to define, so it’s much easier to check if a character is alphanumeric rather than the other way around.

 Edge cases 2

 Does your code work correctly if rotationFactor is greater than 25? How about a rotationFactor of 0?

 Solution approach 1

 Let us first note that, for alphabetic characters, any rotationFactor greater than 25 can be reduced to a factor in the range [0, 25] since rotating 26 times is the same as rotating 0 times. Similarly, when rotating a numeric character, any rotationFactor greater than 9 can be reduced to the range [0, 9]. Subtracting 26 (or 10) repeatedly is a slow way to reduce the factor, so we can instead use modular arithmetic.
 In most languages, the % operator is the modulo operator. A % B returns the remainder after dividing A by B, which is the same as subtracting B repeatedly until you have a value in the range [0, B). Some languages have an explicit mod(A, B) function instead of a first-class operator.

 Solution approach 2

 Once we’ve reduced our factor to a small value, there are a few ways to achieve O(1) rotations per character. Some of these take additional (though constant) space such as making a series of hash tables that map an input character to a ciphered character, one for each level of rotation from 0 to 25. But instead, we can take advantage of the fact that the characters a-z, A-Z, and 0-9 all exist in a contiguous range of ASCII values. Most languages let you convert characters to and from ASCII values, and many let you perform arithmetic directly on characters. If you want to rotate ‘E’ by 5, you can simply compute 'E' + 5 = 'J'.

 Solution approach 3

 We must take care, however, to wrap around if we go past the last character. We don’t want to do 'Z' + 4 = '^'! We can use modular arithmetic once more to avoid this problem. Consider this pseudocode:
 rotateCharacter(c, rotationFactor) {
 return ((c - 'A' + rotationFactor) % 26) + 'A';
 }
 c - 'A' will let us represent each letter as a number from [0, 25]. This step is necessary because the ASCII value of ‘A’ is not 0. We then add the rotation factor (and note that it isn’t actually necessary to reduce it beforehand) and then take this sum modulo 26 to get the [0, 25]-representation of the rotated character. We add ‘A’ back in at the end to translate this value back into the ASCII range of A-Z.
 You can extend this code to properly handle characters in the ranges a-z and 0-9 as well.

 */


//: [Next](@next)

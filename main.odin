/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    main.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "core:fmt"
import "app_version"

main :: proc() {
  fmt.println("Running 'tripass'...")
  fmt.println("Number of 'marks':",len(marks))
  fmt.println("Number of 'words':",len(words))
  app_version.version_show()
}
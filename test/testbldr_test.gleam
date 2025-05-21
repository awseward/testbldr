import birdie
import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import pprint
import testbldr

pub fn main() {
  let test_runner =
    testbldr.test_runner_default()
    |> testbldr.include_passing_tests_in_output(True)
    |> testbldr.output_results_to_stdout()

  let tests =
    list.flatten([
      is_odd_tests(),
      //
      snapshot_tests(),
    ])

  test_runner
  |> testbldr.run(tests)
}

fn is_odd_tests() {
  use n <- list.map([1, 3, 5, 8, 9])
  use <- testbldr.named(int.to_string(n) <> " is odd")
  case n % 2 == 1 {
    True -> testbldr.Pass
    False -> testbldr.Fail(int.to_string(n) <> " is even, not odd")
  }
}

fn snapshot_tests() {
  use n <- list.map([1, 3, 5, 8, 9])
  let title = "snapshot: " <> int.to_string(n) <> " is odd"
  use <- testbldr.named(title)
  use <- snap(title)

  dict.from_list([
    #("n", int.to_string(n)),
    #("is odd", string.inspect({ n % 2 == 1 })),
  ])
  |> pprint.format
}

fn snap(title: String, f: fn() -> String) {
  birdie.snap(f(), title)
  // Always a Pass here because birdie fails by panicking, not a Result
  testbldr.Pass
}

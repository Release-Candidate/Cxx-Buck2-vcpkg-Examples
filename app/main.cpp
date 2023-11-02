// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// Project:  c++-test
// File:     main.cpp
// Date:     30.Oct.2023
//
// ==============================================================================

#include <argparse/argparse.hpp>
#include <cstdlib>
#include <format>
#include <iostream>
#include <memory>

#include "lib/lib.hpp"

/**
 * Parse the command line arguments and return an object containing the result.
 *
 * `argc` - The number of command line arguments.
 * `argv` - The array of command line arguments.
 *
 * Return (`argparse::ArgumentParser`): The object containing the command line
 *                                      arguments.
 */
auto parse_commandline(int argc, char** argv) -> argparse::ArgumentParser {
  argparse::ArgumentParser program("app", "0.1.2");
  program.add_description("This is just a app to test Buck 2 with C++.");
  program.add_epilog(
      "See https://github.com/Release-Candidate/Cxx-Buck2-Examples for "
      "details.");

  try {
    program.parse_args(argc, argv);

  } catch (const std::exception& err) {
    std::cerr << err.what() << '\n';
    std::cerr << program;
    exit(EXIT_FAILURE);  // NOLINT(concurrency-mt-unsafe)
  }

  std::unique_ptr<mpf_class> r =
      mppp_test("1.1897314953572317650857593266280070163e4932");

  std::cout << std::setprecision(100) << "r is " << *r << "\n";

  return program;
}

/**
 * The main entry point of the program.
 *
 * `argc` - The number of command line arguments.
 * `argv` - The array of command line arguments.
 *
 * Return (`int`): 0 on success, 1 - `EXIT_FAILURE` on errors.
 */
auto main(int argc, char** argv) -> int {
  std::cout << std::format("HI, foo(42) said {}\n", foo(42));

  auto program = parse_commandline(argc, argv);

  return EXIT_SUCCESS;
}

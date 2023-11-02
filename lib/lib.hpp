// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: MIT
//
// Project:  c++-test
// File:     lib.hpp
// Date:     31.Oct.2023
//
// ==============================================================================

#include <gmpxx.h>
#include <memory>
#include <string>

/**
 * Return `i` as a string.
 *
 * `i` - The `int` to convert to a string.
 *
 * Return (`std::string`): `i` as string.
 */
auto foo(int i) -> std::string;

auto mppp_test(const std::string& s) -> std::unique_ptr<mpf_class>;

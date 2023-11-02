// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: MIT
//
// Project:  c++-test
// File:     lib.cpp
// Date:     31.Oct.2023
//
// ==============================================================================

#include <format>
#include "gmpxx.h"

#include "lib.hpp"

auto foo(int i) -> std::string {
  return std::format("{}", i);
}

auto mppp_test(const std::string& s) -> std::unique_ptr<mpf_class> {
  auto ret_val = std::make_unique<mpf_class>(mpf_class(s, 128));
  return ret_val;
}

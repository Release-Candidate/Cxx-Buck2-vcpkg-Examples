// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: MIT
//
// Project:  c++-test
// File:     test_main.cpp
// Date:     01.Nov.2023
//
// ==============================================================================

#include <exception>  // IWYU pragma: keep - rapidcheck.h needs that

#include <gtest/gtest.h>
#include <rapidcheck.h>
#include <format>

#include "lib/lib.hpp"

TEST(testTest, int5ToString) {
  EXPECT_EQ(foo(5), "1");
}

TEST(testTest, rapidCheckIntToString) {
  EXPECT_TRUE(rc::check([](const int& n) {
    return RC_ASSERT(foo(n) == std::format("{}", n + 1));
  }));
}

// No `main` needed, `libgtest_main` contains it.

# Ejecutable de Tests
add_executable(unit_tests
            "./hello_test.cpp"
            "./led_service_test.cpp"
        )
# Enlazar
target_link_libraries(unit_tests
    app_lib
    GTest::gtest_main
    GTest::gmock
)

include(GoogleTest)
gtest_discover_tests(unit_tests)
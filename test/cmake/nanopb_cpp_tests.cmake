set(TEST_COMMON_DIR ${CMAKE_CURRENT_LIST_DIR}/../common)

function(nanopb_cpp_add_test TEST)
    set(multiValueArgs SRC PROTO)
    cmake_parse_arguments(NANOPB_CPP_ADD_TEST "" "" "${multiValueArgs}" ${ARGN})

    set(EXECUTABLE "test_${TEST}")
    set(TEST_FOLDER  ${CMAKE_CURRENT_SOURCE_DIR})

    if(NOT EXISTS "${TEST_FOLDER}")
        message(FATAL_ERROR "Test folder does not exists: ${TEST_FOLDER}")
    endif()

    set(TEST_SOURCES ${NANOPB_CPP_ADD_TEST_SRC})
    set(TEST_PROTOS ${NANOPB_CPP_ADD_TEST_PROTO})

    if (NOT TEST_SOURCES)
        message(FATAL_ERROR "SRC should not be empty")
    endif()

    if (NOT TEST_PROTOS)
        message(FATAL_ERROR "PROTO should not be empty")
    endif()

    if (TEST_PROTOS)
        foreach(PROTO ${TEST_PROTOS})
            get_filename_component(PROTO_ABS ${PROTO} ABSOLUTE)
            list(APPEND TEST_PROTOS_ABS ${PROTO_ABS})
        endforeach()
        set(NANOPB_OPTIONS --error-on-unmatched)

        nanopb_generate_cpp(
                PROTO_SRCS
                PROTO_HDRS
                ${TEST_PROTOS_ABS}
        )
        list(APPEND TEST_SOURCES ${PROTO_SRCS} ${PROTO_HDRS})
    endif()

    add_executable(${EXECUTABLE}
            ${TEST_SOURCES}
            ${PROJECT_SOURCE_DIR}/nanopb_cpp.cpp
            )

    target_include_directories(${EXECUTABLE} PRIVATE
            ${TEST_FOLDER}
            ${PROJECT_SOURCE_DIR}
            ${TEST_COMMON_DIR}
            ${NANOPB_ROOT}
            ${CMAKE_CURRENT_BINARY_DIR}
            )

    if (NANOPB_CPP_ENABLE_TESTS_SANITIZE)
        target_link_libraries(${EXECUTABLE}  -fsanitize=address)
    endif()

    add_test(NAME ${TEST} COMMAND ${EXECUTABLE})
endfunction()
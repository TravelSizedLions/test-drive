class_name ExampleTDTest extends TDTest

# override this function in order to run your tests.
func test_drive():
  before_each(func():
    # this will get called before every test in this file.
    # it's useful for doing repeated setups
    print('before_each() called!')
  )

  after_each(func():
    # this will get called after every test in this file.
    # if there's something that should be cleaned up after
    # every test, put it in an after_each()
    print('after_each() called!\n')
  )

  Skip.test('prefixing tests with Skip means that test drive ignores them')

  Skip.group('you can also skip entire groups if needed!', func():
    test("This test gets skipped!")

    test('So does this one!')
  )

  group('this is a group', func():
    # put your tests in groups to label basic areas of functionality.
    # groups are cleanly organized in the test runner output.

    before_each(func():
      # this will get called before every test in this group.
      # it will be called after any before_each() functions in parent groups.
      pass
    )

    after_each(func():
      # this will get called after every test in this group.
      # it will be called after any after_each() functions in parent groups.
      pass
    )

    test('this is a test', func():
      # test individual behaviors of your code in a test() block
      assert_true(true)
    )
  )

  group('outer group', func():
    # groups and tests can be nested as deeply as you need.
    # tests can go anywhere before, inside, or after a group.
    test('test before inner group', func():
      pass	
    )
    
    group('inner group', func():
      test('test inside inner group', func():
        pass
      )
    )

    test('test after inner group', func():
      pass	
    )
  )

  test('top level test', func():
    # tests don't necessarily have to live in groups.
    # groups are just for organization.
    pass
  )
  
  test('failthrough testing', func():
    # if one of these assertions fails, the test will not proceed to the
    # next one. It'll "fail through" to the end of the test
    # and report where the first failed assertion happened.
    assert_equal(true, true)
    assert_equal(true, true)
    assert_equal(false, false)
  )

  before_all(func():
    # this will be called once, before any test is evaluated.
    # use it to perform one-time setup for the test file.
    # 
    # before_all() can be used within groups as well, though it's not recommended.
    # if used within a group, the callback will be performed once, before any
    # test in the group.
    print('before_all() called!')
  )

  after_all(func():
    # this will be called once, after all tests have been evaluated.
    # use it to perform one-time tear-down for the test file.
    # 
    # after_all() can be used within groups as well, though it's not recommended.
    # if used within a group, the callback will be performed once, after every
    # test in the group.
    print('after_all() called!')
  )

class_name MockingTests extends TDTest

var ZeroArgsMock
var OneRequiredArgMock
var TwoRequiredArgMock
var OnlyOptionalArgsMock
var MixedArgsMock

func test_drive():
  group('class variables', func():
    test('mocks can override class variables', func():
      var mocked = mock(TestClass.NoArgs)
      mocked.name = 'replaced!'
      mocked.__thing = 'also replaced!'
      
      var instance = mocked.new()
      assert_equal(instance.name, 'replaced!')
      assert_equal(instance.__thing, 'also replaced!')
    )

    test('mocks can use the the original variable value', func():
      var mocked = mock(TestClass.NoArgs)
      mocked.use_defaults()
      var instance = mocked.new()
      assert_equal(instance.name, 'Test!')
      assert_equal(instance.__thing, '')
    )

    test('mocks use override values instead of the default when provided', func():
      var mocked = mock(TestClass.NoArgs)
      mocked.use_defaults()
      mocked.name = 'i do wat i want'
      mocked.__thing = 'i do too'
      var instance = mocked.new()
      assert_equal(instance.name, 'i do wat i want')
      assert_equal(instance.__thing, 'i do too')
    )
  )

  group('setters and getters', func():
    test('properties with getters and setters can be overridden', func():
      var mocked = mock(TestClass.NoArgs)
      mocked.thing = 'thing'
      var instance = mocked.new()

      assert_equal(instance.thing, 'thing')
      assert_equal(instance.other_thing, '')
    ) 

    test('properties are set to their default values when appropriate', func():
      var mocked = mock(TestClass.NoArgs)
      mocked.thing = 'low'
      mocked.use_defaults()
      var instance = mocked.new()

      assert_equal(instance.thing, 'low')
      assert_equal(instance.other_thing, 'hi')
    )
  )

  group('functions - no default implementation', func():
    test('mocks can be initialized with no args (real class has no args)', func():
      TDLogger.errors_only(func():
        var MockTest = mock(TestClass.NoArgs)
        var instance = MockTest.new()
        assert_null(instance.returns_true())
        assert_null(instance.returns_false())
        assert_null(instance.returns_string('hah!'))
      )
    )

    test('mocks can be initialized with no args (real class has only required init args)', func():
      TDLogger.errors_only(func():
        var MockTest = mock(TestClass.OneRequiredArg)
        var instance = MockTest.new()
        assert_null(instance.a())
      )
    )

    test('mocks can be initialized with no args (real class has only optional init args)', func():
      TDLogger.errors_only(func():
        var MockTest = mock(TestClass.OnlyOptionalArgs)
        var instance = MockTest.new()
        assert_null(instance.a())
        assert_null(instance.b())
      )
    )

    test('mocks can be initialized with no args (real class has a mix of optional and required args)', func():
      TDLogger.errors_only(func():
        var MockTest = mock(TestClass.MixedArgs)
        var instance = MockTest.new()
        assert_null(instance.a())
        assert_null(instance.b())
      )
    )
  )

  group('functions - with default implementation', func():
    group('zero-argument initializers', func():
      before_each(func():
        ZeroArgsMock = mock(TestClass.NoArgs)
        ZeroArgsMock.use_defaults()
      )

      test('mocks can be initialized with no args and uses default implementation', func(): 
        var mock = ZeroArgsMock.new()
        assert_false(mock.returns_false())
        assert_true(mock.returns_true())
        assert_equal(mock.returns_string('Test'), 'Test')
      )

      test('mocks initialized with too many args skip the default implementation', func():
        TDLogger.errors_only(func():
          var mock = ZeroArgsMock.new(1, 2, 3)
          assert_null(mock.returns_false())
          assert_null(mock.returns_true())
          assert_null(mock.returns_string('Test'))
        )
      )
    )

    group('only required arguments in initializer', func():
      before_each(func():
        OneRequiredArgMock = mock(TestClass.OneRequiredArg)
        TwoRequiredArgMock = mock(TestClass.TwoRequiredArgs)
        OneRequiredArgMock.use_defaults()
        TwoRequiredArgMock.use_defaults()
      )

      test('skip using original implementation when there is an argument type mismatch', func():
        TDLogger.errors_only(func():
          var mock_1 = OneRequiredArgMock.new('this string is a number i swear')
          var mock_2 = TwoRequiredArgMock.new(1, 'this is also definitely a number i promise')
          assert_null(mock_1.a())
          assert_null(mock_2.a())
          assert_null(mock_2.b())
        )
      )

      test('use the original implementation when all required arguments are passed', func():
        var mock_1 = OneRequiredArgMock.new(1)
        var mock_2 = TwoRequiredArgMock.new(2, 3)
        assert_equal(mock_1.a(), 1)
        assert_equal(mock_2.a(), 2)
        assert_equal(mock_2.b(), 3)
      )

      test('skip using the original implementation when there are not enough arguments passed', func():
        TDLogger.errors_only(func():
          var mock_1 = OneRequiredArgMock.new()
          var mock_2 = TwoRequiredArgMock.new(1)
          assert_null(mock_1.a())
          assert_null(mock_2.a())
          assert_null(mock_2.b())
        )
      )

      test('skip using the original implementation when too many arguments are passed', func():
        TDLogger.errors_only(func():
          var mock_1 = OneRequiredArgMock.new(1, 2)
          var mock_2 = TwoRequiredArgMock.new(1, 2, 3, 4, 5, [6, 7, 8, 9, 10])
          assert_null(mock_1.a())
          assert_null(mock_2.a())
          assert_null(mock_2.b())
        )
      )
    )

    group('only optional args in initializer', func():
      before_each(func():
        OnlyOptionalArgsMock = mock(TestClass.OnlyOptionalArgs)
        OnlyOptionalArgsMock.use_defaults()
      )
      
      test('mocks utilize the default arguments of the real initializer', func():
        var mock_0 = OnlyOptionalArgsMock.new()
        assert_equal(mock_0.a(), 1)
        assert_equal(mock_0.b(), 1)

        var mock_1 = OnlyOptionalArgsMock.new(2)
        assert_equal(mock_1.a(), 2)
        assert_equal(mock_1.b(), 1)

        var mock_all = OnlyOptionalArgsMock.new(2, 2) 
        assert_equal(mock_all.a(), 2)
        assert_equal(mock_all.b(), 2)
      )

      test('skip using the original implementation when there is a type mismatch', func():
        TDLogger.errors_only(func():
          var bad_mock = OnlyOptionalArgsMock.new(2, 'i am definitely a number and there is nothing suspect going on')
          assert_null(bad_mock.a())
          assert_null(bad_mock.b())
        )
      )

      test('skip using the original implementation when too many arguments are passed', func():
        TDLogger.errors_only(func():
          var bad_mock = OnlyOptionalArgsMock.new(0, 0, 0, 0, 0, [0, 0])
          assert_null(bad_mock.a())
          assert_null(bad_mock.b())
        )
      )
    )

    group('mixed-argument initializers', func(): 
      before_each(func():
        MixedArgsMock = mock(TestClass.MixedArgs)
        MixedArgsMock.use_defaults()
      )

      test('skipping required arguments skips using default implementations', func():
        TDLogger.errors_only(func():
          var mock = MixedArgsMock.new()
          assert_null(mock.a())
          assert_null(mock.b())
        )
      )

      test('passing in all required arguments uses the original implementation', func():
        var mock = MixedArgsMock.new(1)
        assert_equal(mock.a(), 1)
        assert_equal(mock.b(), 1)
      )

      test('passing in all required AND optional arguments uses the original implementation', func():
        var mock = MixedArgsMock.new(1, 2)
        assert_equal(mock.a(), 1)
        assert_equal(mock.b(), 2)
      )

      test('skip using the original implementation when there is a type mismatch', func():
        TDLogger.errors_only(func():
          var bad_required = MixedArgsMock.new('i am definitely a number and there is nothing suspect going on')
          var bad_optional = MixedArgsMock.new(2, 'i am definitely a number and there is nothing suspect going on')
          assert_null(bad_required.a())
          assert_null(bad_required.b())
          assert_null(bad_optional.a())
          assert_null(bad_optional.b())
        )
      )

      test('skip using the original implementation when too many arguments are passed', func():
        TDLogger.errors_only(func():
          var mock = MixedArgsMock.new(1, 2, 3, 4, 5, ['passing', 'in', 'wayyyyyyyyy', 'too', 'many', 'args'])
          assert_null(mock.a())
          assert_null(mock.b())
        )
      )
    )
  )

class_name OnlySkipTests extends TDTest

func test_drive():
  var ref_a = {}
  before_all(func():
    ref_a['before_all'] = true
  )

  after_all(func():
    ref_a['after_all'] = true
  )

  before_each(func():
    ref_a['before_each'] = true
  )

  after_each(func():
    ref_a['after_each'] = true
  )

  Skip.group('group a', func():
    test('test 0')

    group('group b', func():
      test('test 1')

      Only.test('test 2')

      group('group c', func():
        test('test 3')

        Only.test('test 4')  
      )
    )
    
    Only.group('group d', func():
      var ref_b = {}

      before_all(func():
        ref_b['before_all'] = true
      )

      after_all(func():
        ref_b['after_all'] = true
      )

      before_each(func():
        ref_b['before_each'] = true
      )

      after_each(func():
        ref_b['after_each'] = true
      )

      Skip.test('test 5')

      test('test 6')

      group('group e', func():
        test('test 7', func():
          assert_true(ref_a['before_all'])  
          assert_true(ref_a['before_each'])  
          assert_true(ref_a['after_each'])  
          assert_true(ref_b['before_all'])  
          assert_true(ref_b['before_each'])  
          assert_true(ref_b['after_each']) 
        )  
      )  
    )

    Only.group('group f')
  )
